-- lua/plugins/which-key.lua

return {
    "folke/which-key.nvim",
    event = "VimEnter", -- Load the plugin on startup
    config = function()
        require("which-key").setup({
            -- your setup options here
        })

        -- Register the keymap groups to provide descriptions in the popup
        require("which-key").add({
            -- Note: Groups 'd', 'r', 's', 'h' from the old config are removed
            -- as their mappings have been integrated into other groups.
            { "<leader>a", group = "[A]I" },
            { "<leader>b", group = "[B]uffer" },
            { "<leader>c", group = "[C]ode" },
            { "<leader>f", group = "[F]ind" },
            { "<leader>g", group = "[G]it" },
            { "<leader>t", group = "[T]oggle" },
            { "<leader>w", group = "[W]indow" },
        })
    end,
}
