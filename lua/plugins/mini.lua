return {
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        dependencies = {
            { "echasnovski/mini.ai" },
            { "echasnovski/mini.diff" },
            { "echasnovski/mini-git" },
        },
        version = "*", -- stable
        keys = {
            {
                "<leader>td",
                "<cmd>lua MiniDiff.toggle_overlay()<cr>",
                desc = "[T]oggle live inline [D]iff overlay",
            },
        },
        event = "VeryLazy",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 50 })

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin

            require("mini.git").setup()
            require("mini.diff").setup()
            local statusline = require("mini.statusline")
            -- set use_icons to true if you have a Nerd Font
            statusline.setup({ use_icons = vim.g.have_nerd_font })

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function() return "%2l:%-2v" end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
}
