return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            -- Set light or dark variant
            variant = "light", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

            -- Enable transparent background
            transparent = true,

            -- Replace all fillchars with ' ' for the ultimate clean look
            hide_fillchars = false,

            -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
            borderless_pickers = false,

            -- Set terminal colors used in `:terminal`
            terminal_colors = true,

            highlights = {
                LspInfoBorder = { fg = "White" },
                FloatBorder = { fg = "White" },
                NormalFloat = { bg = nil },
                TelescopeBorder = { fg = "#999999", bold = true },
                Visual = { bg = "#999999" },
                WinSeparator = { fg = "#999999" },
            },
            -- Disable or enable colorscheme extensions
            extensions = {
                telescope = true,
                mini = true,
                lazy = true,
                treesitter = true,
                whichkey = true,
                alpha = true,
                cmp = true,
            },
        })
    end,
}
