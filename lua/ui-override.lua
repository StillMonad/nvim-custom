-- Custom UI override
-- vim.cmd.colorscheme("cyberdream")
-- vim.cmd("CyberdreamToggleMode")
-- vim.cmd("highlight LineNr guifg=#f6b26b")
-- vim.cmd("highlight BufferDefaultInactive guifg=#ffffff")
-- vim.cmd.colorscheme("rose-pine-moon")

vim.cmd("highlight Visual guibg=#561ff8")
vim.cmd("highlight CurSearch guibg=#8862fa guifg=#ffffff")
vim.cmd("highlight Search guibg=#3c15ad")
vim.cmd("highlight CursorLine guibg=#2b0f7c")


vim.opt.fillchars = {
    vert = "│", -- alternatives ▕
    fold = " ",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
    stlnc = " ",
    stl = " ",
}

vim.diagnostic.config({
    virtual_text = false,
    float = {
        header = false,
        border = "rounded",
        focusable = true,
    },
})
-- alpha-config.lua

local status_ok, _ = pcall(require, "alpha")
if not status_ok then return end

-- set MiniStatusLine highlight overrides
-- vim.cmd("highlight MiniStatusLineDevInfo guibg=#3b3b3b")
-- vim.cmd("highlight MiniStatusLineFilename guibg=#3b3b3b")
-- vim.cmd("highlight StatusLineNC guibg=#3b3b3b")


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- Highlight yanked text
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    desc = "Highlight selection on yank",
    pattern = "*",
    callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 }) end,
})

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- Force lsp popups to have rounded borders
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
local original_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
    -- Merge our custom border option into any existing options.
    opts = vim.tbl_deep_extend("force", {
        border = "rounded",
    }, opts or {})
    -- Call the original function with the modified options.
    return original_open_floating_preview(contents, syntax, opts)
end

-- This autocmd will run whenever a colorscheme is loaded.
-- It's the most reliable way to set the COLOR of the borders.
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("GlobalUIHighlights", { clear = true }),
    desc = "Set global UI highlights after colorscheme loads",
    callback = function ()
        -- Set the border of all floating windows to white.
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#FFFFFF" })
        -- Set the color of the vertical AND horizontal lines between window splits to white.
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#FFFFFF" })
    end
})


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- ToggleTerm bg reset on opening
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- Create a dedicated augroup to ensure the autocmd is not duplicated
-- when you reload your configuration.
local augroup = vim.api.nvim_create_augroup("ToggleTermGui", { clear = true })

-- Create the autocommand that listens for ToggleTermOpen
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = "*", -- Match all toggleterm windows
  desc = "Set transparent background for ToggleTerm",
  callback = function()
    -- When a toggleterm window opens, execute this highlight command
    vim.cmd("highlight ToggleTerm1Normal guibg=NONE")
  end,
})
