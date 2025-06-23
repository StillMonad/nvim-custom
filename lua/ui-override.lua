-- Custom UI override
vim.cmd.colorscheme("cyberdream")

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

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- This is the definitive fix for forcing all LSP floating windows
-- to have a specific border style. It wraps the function that Neovim's
-- LSP client uses to show hover docs, signature help, etc.
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
    callback = function()
        -- Set the border of all floating windows to white.
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#FFFFFF" })
        -- Set the color of the vertical AND horizontal lines between window splits to white.
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#FFFFFF" })
    end,
})
