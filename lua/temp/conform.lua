return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- uncomment for format on save
        keys = {
            { "<leader>e", ":NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
        },
        config = function()
            local options = {
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "ruff" },
                    css = { "prettier" },
                    html = { "prettier" },
                    php = { "php-cs-fixer" },
                },

                format_on_save = {
                    -- These options will be passed to conform.format()
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            }

            require("conform").setup(options)
        end,
    },
}
