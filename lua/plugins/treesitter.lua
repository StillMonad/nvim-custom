return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TsUpdate",
        opts = {
            highlight = {
                enable = true,
                disable = "help",
            },
            indent = {
                enable = true,
            },
            auto_install = true,
            ensure_installed = {
                "vim",
                "vimdoc",
                "lua",
                "luadoc",
                "markdown",
                "vimdoc",
                "html",
                "css",
                "python",
                "php",
            },
        },
        setup = function()
            require("telescope").setup({
                defaults = {
                    layout_config = {
                        vertical = { width = 0.5 },
                        -- other layout configuration here
                    },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                    },
                },
                extensions = {
                    -- ...
                },
            })
        end,
        lazy = false,
    },
}
