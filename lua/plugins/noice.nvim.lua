return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any of these icons, make sure to add them here
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                cmdline = {
                    view = "cmdline",
                },
                views = {
                    -- override the default cmdline_popup view
                    cmdline_popup = {
                        position = {
                            row = "70%", -- Position it 90% from the top
                            col = "50%", -- Center it horizontally
                        },
                        size = {
                            width = "60%", -- Make it 60% of the screen width
                            -- height = "auto", -- The height will grow with content
                        },
                        border = {
                            style = "rounded",
                            padding = { 0, 0 },
                        },
                    },
                },
                messages = {
                    view_search = "notify",
                },
                presets = {
                    -- you can enable a preset by setting it to true, or a table that will override the preset config
                    -- you can also add custom presets that you can enable/disable with enabled=true
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = false, -- position the cmdline and popupmenu together
                    long_message_to_split = false, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },
}
