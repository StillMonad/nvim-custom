-- lua/misc/ollama_ghost.lua
-- Inline ghost-text completions via local Ollama (async, buffer-only).

local M = {}

-- ===================== Config / State =====================
M.state = {
  enabled = true,
  model = "qwen2.5-coder:1.5b-base",   -- prefer *base* coder models
  endpoint = "http://127.0.0.1:11434/api/generate",
  temperature = 0,
  num_predict = 100,                     -- tiny chunk → snappy & not glue-y
  debounce_ms = 300,
  curl_timeout_s = "1.2",               -- bump if your model is slow
  use_fim = true,                       -- when ON → use Ollama infill (prompt+suffix, raw=false)
  fim_type = "auto",                    -- kept for UX; Ollama infill handles tokens internally
}

-- Per-buffer ephemeral
local ns = vim.api.nvim_create_namespace("ollama_ghost")
local aug = "OllamaGhostAutocmds"
local timers   = {}   -- bufnr -> uv_timer
local inflight = {}   -- bufnr -> request token (seq)
local marks    = {}   -- bufnr -> extmark id
local last_sig = {}   -- bufnr -> signature (to dedupe)

-- ===================== Utils =====================
local function schedule(fn) if vim.in_fast_event() then vim.schedule(fn) else fn() end end

local function is_real_window(win)
  win = win or vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(win)
  return cfg.relative == "" -- not a floating window
end

local function buf_ok(bufnr)
  return bufnr
     and vim.api.nvim_buf_is_loaded(bufnr)
     and vim.bo[bufnr].buftype == ""
     and vim.bo[bufnr].modifiable
end

local function clear_mark(bufnr)
  if not buf_ok(bufnr) then return end
  if marks[bufnr] then
    pcall(vim.api.nvim_buf_del_extmark, bufnr, ns, marks[bufnr])
    marks[bufnr] = nil
  end
end

local function set_ghost(bufnr, row, col, text)
  if not buf_ok(bufnr) or not is_real_window() then return end
  clear_mark(bufnr)
  if not text or text == "" then return end
  marks[bufnr] = vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {
    virt_text = { { text, "Comment" } },
    virt_text_pos = "inline",
    hl_mode = "combine",
  })
end

local function list_models()
  if vim.fn.executable("ollama") == 0 then return {} end
  local out = vim.fn.systemlist({ "ollama", "list" })
  if vim.v.shell_error ~= 0 then return {} end
  local t = {}
  for _, line in ipairs(out) do
    local name = line:match("^(%S+)")
    if name then table.insert(t, name) end
  end
  return t
end

-- ===================== Context & Signature =====================
local function current_ctx()
  if not is_real_window() then return nil end
  local bufnr = vim.api.nvim_get_current_buf()
  if not buf_ok(bufnr) then return nil end
  local pos = vim.api.nvim_win_get_cursor(0)  -- {row, col}
  local row, col = pos[1]-1, pos[2]
  local ft = vim.bo[bufnr].filetype or "text"
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row+1, false)[1] or ""
  local prefix = line:sub(1, col)
  local suffix = line:sub(col+1)
  return { bufnr=bufnr, row=row, col=col, filetype=ft, line=line, prefix=prefix, suffix=suffix }
end

local function signature(ctx)
  -- Dedupe by position + tails/heads (so tiny edits still trigger)
  local pre_tail = ctx.prefix:sub(-32)
  local suf_head = ctx.suffix:sub(1, 32)
  return table.concat({ ctx.filetype, tostring(ctx.row), tostring(ctx.col), pre_tail, suf_head }, "\n")
end

local function stop_timer(bufnr)
  local t = timers[bufnr]
  if t then t:stop(); t:close(); timers[bufnr] = nil end
end

-- ===================== Request (async) =====================
local function curl_args(body)
  return {
    "curl", "-sS", "--max-time", M.state.curl_timeout_s,
    "-H", "Content-Type: application/json",
    "-X", "POST",
    "-d", vim.json.encode(body),
    M.state.endpoint,
  }
end

local function request_ghost(ctx)
  if not ctx or not buf_ok(ctx.bufnr) or not is_real_window() or not M.state.enabled then return end

  local use_infill = M.state.use_fim
  if (not use_infill and #ctx.prefix < 1) or (#ctx.prefix < 1 and #ctx.suffix < 1) then
    -- non-FIM needs some prefix; FIM can run with only suffix
    clear_mark(ctx.bufnr); return
  end

  -- Dedupe identical situation
  local sig = signature(ctx)
  if last_sig[ctx.bufnr] == sig then return end
  last_sig[ctx.bufnr] = sig

  -- Cancel previous by bumping token
  inflight[ctx.bufnr] = (inflight[ctx.bufnr] or 0) + 1
  local my_token = inflight[ctx.bufnr]

  -- Build request body
  local body
  if use_infill then
    body = {
      model   = M.state.model,
      prompt  = ctx.prefix,   -- LEFT of cursor
      suffix  = ctx.suffix,   -- RIGHT of cursor
      stream  = false,
      raw     = false,        -- let Ollama apply infill template/tokens
      options = {
        temperature = M.state.temperature,
        num_predict = M.state.num_predict,
        top_k = 1,
        stop = { "\n", "\r", "</s>" }, -- keep single-line
      },
    }
  else
    body = {
      model   = M.state.model,
      prompt  = table.concat({
        "You are a code completion engine. Continue from the cursor.",
        "Return ONLY the completion to insert (no quotes/markdown).",
        "Do NOT repeat the already-typed prefix.",
        "Filetype: " .. ctx.filetype,
        "\nPrefix:\n" .. ctx.prefix .. "\nSuffix:\n" .. ctx.suffix .. "\nCompletion:",
      }, "\n"),
      stream  = false,
      raw     = true,         -- bypass chat templates
      options = {
        temperature = M.state.temperature,
        num_predict = M.state.num_predict,
        top_k = 1,
        stop = { "\n", "\r", "</s>", "#", ";", "##" },
      },
    }
  end

  vim.system(curl_args(body), {}, function(obj)
    schedule(function()
      -- If another request started after this one, ignore this result
      if not buf_ok(ctx.bufnr) or my_token ~= inflight[ctx.bufnr] then return end

      if obj.code ~= 0 or not obj.stdout or obj.stdout == "" then
        clear_mark(ctx.bufnr); return
      end
      local ok, decoded = pcall(vim.json.decode, obj.stdout)
      if not ok or type(decoded) ~= "table" or type(decoded.response) ~= "string" then
        clear_mark(ctx.bufnr); return
      end

      -- Sanitize
      local text = decoded.response or ""
      text = text:gsub("[%z\1-\31]", "")             -- drop control chars (incl. NUL -> ^@)
      text = (text:match("^[^\r\n]*") or "")         -- first line only
      text = text:gsub("^%s+", ""):gsub("%s+$", "")  -- trim

      -- Defensive truncation / structure guards
      local suffix = ctx.suffix or ""
      if #suffix > 0 and text ~= "" then
        -- If completion starts duplicating the right side, remove overlap
        local common = 0
        for i = 1, math.min(#text, #suffix) do
          if text:sub(i,i) == suffix:sub(i,i) then common = i else break end
        end
        if common > 0 then text = text:sub(common+1) end
      end

      -- If right side starts with a bracket/paren, cut completion up to that closer
      local closer = (suffix:sub(1,1) or "")
      if closer:match("[%]%})%)]") then
        local i = text:find(vim.pesc(closer), 1, true)
        if i then text = text:sub(1, i) end
      end

      -- Avoid glued calls/statements (e.g., print(...)print(...))
      local newstmt = text:find("[%w_]+%s*%(", 2)  -- allow first token, cut at next call
      if newstmt and newstmt > 1 then
        text = text:sub(1, newstmt - 1)
      end

      -- Final safety: cap visible length
      if #text > 64 then text = text:sub(1, 64) end

      set_ghost(ctx.bufnr, ctx.row, ctx.col, text)
    end)
  end)
end

-- Debounced trigger from events
local function debounced_request()
  local ctx = current_ctx()
  if not ctx then return end
  local b = ctx.bufnr
  stop_timer(b)
  local t = vim.loop.new_timer()
  timers[b] = t
  t:start(M.state.debounce_ms, 0, function()
    schedule(function() request_ghost(ctx) end)
  end)
end

-- ===================== Public API / Commands =====================
function M.toggle()
  M.state.enabled = not M.state.enabled
  if not M.state.enabled then
    for b,_ in pairs(marks) do clear_mark(b) end
    for b,_ in pairs(timers) do stop_timer(b) end
  else
    schedule(function() debounced_request() end)
  end
  schedule(function()
    vim.notify("[ollama-ghost] " .. (M.state.enabled and "enabled" or "disabled"))
  end)
end

function M.set_model(name)
  if not name or name == "" then
    schedule(function()
      vim.notify("[ollama-ghost] usage: :OllamaGhostModel <model>", vim.log.levels.WARN)
    end)
    return
  end
  M.state.model = name
  schedule(function()
    vim.notify("[ollama-ghost] model set to " .. name)
    debounced_request()
  end)
end

function M.set_fim(on)
  local val = tostring(on):lower()
  if     val == "on" or val == "true" or val == "1" then M.state.use_fim = true
  elseif val == "off" or val == "false" or val == "0" then M.state.use_fim = false
  else
    schedule(function()
      vim.notify("[ollama-ghost] usage: :OllamaGhostFIM on|off", vim.log.levels.WARN)
    end)
    return
  end
  schedule(function()
    vim.notify("[ollama-ghost] FIM " .. (M.state.use_fim and "ON" or "OFF"))
    debounced_request()
  end)
end

function M.accept()
  local win = vim.api.nvim_get_current_win()
  if not is_real_window(win) then return end
  local bufnr = vim.api.nvim_get_current_buf()
  if not buf_ok(bufnr) or not marks[bufnr] then return end
  local ext = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, marks[bufnr], { details = true })
  if not ext or not ext[3] or not ext[3].virt_text then return end
  local parts = ext[3].virt_text
  local text = ""
  for _, seg in ipairs(parts) do text = text .. (seg[1] or "") end
  if text == "" then return end
  vim.api.nvim_put({ text }, "c", true, true)
  clear_mark(bufnr)
end

function M.setup(opts)
  M.state = vim.tbl_deep_extend("force", M.state, opts or {})

  -- Commands
  vim.api.nvim_create_user_command("OllamaGhostToggle", function() M.toggle() end, {})
  vim.api.nvim_create_user_command("OllamaGhostModel", function(cmd) M.set_model(cmd.args) end, {
    nargs = 1, complete = function() return list_models() end,
  })
  vim.api.nvim_create_user_command("OllamaGhostFIM", function(cmd) M.set_fim(cmd.args) end, { nargs = 1 })
  vim.api.nvim_create_user_command("OllamaGhostAccept", function() M.accept() end, {})

  -- Autocmds (buffer + real window only)
  vim.api.nvim_create_augroup(aug, { clear = true })

  vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
    group = aug,
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if not is_real_window(win) then return end
      clear_mark(vim.api.nvim_get_current_buf())
    end,
  })

  vim.api.nvim_create_autocmd({ "TextChangedI", "CursorMovedI" }, {
    group = aug,
    callback = function()
      if not M.state.enabled or not is_real_window() then return end
      debounced_request()
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = aug,
    callback = function()
      if not M.state.enabled or not is_real_window() then return end
      schedule(function() debounced_request() end)
    end,
  })
end

return M

