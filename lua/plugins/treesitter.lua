return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
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
                    "javascript",
                    "typescript",
                },
                sync_install = false,
                ignore_install = {},
                modules = {},
            })
        end,
        setup = function()
            require("telescope").setup({})
            vim.cmd("TSUpdate")
        end,
        lazy = false,
    },
}
