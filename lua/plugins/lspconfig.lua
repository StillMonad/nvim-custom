-- lua/plugins/lspconfig.lua
-- This file contains the setup for Mason, Conform, LSP, and CMP.

return {
    -- ============== Formatting (conform.nvim) =============== --
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" }, -- loads before first save
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                notify_on_error = true,

                -- auto-fomat on save
                -- format_on_save = {
                --     lsp_fallback = true,
                --     timeout_ms = 500,
                -- },

                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "ruff_format", "ruff_fix" },
                    sh = { "shfmt" },
                    php = { "pint" },
                    toml = { "taplo" },
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    vue = { "prettierd" },
                    json = { "prettierd" },
                    yaml = { "prettierd" },
                    markdown = { "prettierd" },
                    html = { "prettierd" },
                    css = { "prettierd" },
                    scss = { "prettierd" },
                },
            })
        end,
    },

    -- ============== LSP Configuration (mason-lspconfig) =============== --
    {
        "mason-org/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    ensure_installed = {
                        "stylua",
                        "ruff",
                        "shfmt",
                        "prettierd",
                        "pint",
                        "taplo",
                    },
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                },
            },
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            require("mason").setup()
            mason_lspconfig.setup({
                automatic_enable = {
                    exclude = {
                        "jedi_language_server",
                    }
                },
                ensure_installed = {
                    "pyright",
                    "ruff",
                    "jedi_language_server",
                    "ts_ls",
                    "html",
                    "cssls",
                    "lua_ls",
                    "bashls",
                    "intelephense",
                    "dockerls",
                    "yamlls",
                    "taplo",
                },
                handlers = handlers,
            })
        end,
    },

    -- ======= lsp-servers settings (nvim-lspconfig) ========== --
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("lua_ls", require("configs.lua_ls"))
            vim.lsp.config("pyright", require("configs.pyright"))
            vim.lsp.config("ruff", require("configs.ruff"))
            -- vim.lsp.config("jedi_language_server", require("configs.jedi_language_server"))
        end,
    },

    -- ============== Autocompletion (nvim-cmp) =============== --
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "windwp/nvim-autopairs",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- ============== Snippet Engine & Autopairs ============== --
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
}
