-- lua/custom/plugins/core_dev_setup.lua
-- Minimal LSP, Formatter, and Completion setup for Lua

return {
    -- ============== I. Mason - Tool Installer =============== --
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
        opts = { -- Using opts will run mason.setup(opts)
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- ============== II. Formatting (conform.nvim) =============== --
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" }, -- Or "VeryLazy" or on specific filetypes
        cmd = { "ConformInfo" },
        opts = {
            notify_on_error = true,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true, -- Fallback to LSP formatting if conform fails
            },
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                sh = { "shfmt" },
            },
        },
        init = function() -- Optional: Ensure keymap for manual formatting is set
            vim.keymap.set(
                { "n", "v" },
                "<leader>cf",
                function() require("conform").format({ async = true, lsp_fallback = true }) end,
                { desc = "Format buffer with Conform" }
            )
        end,
    },

    -- ============== III. LSP Configuration (mason-lspconfig & nvim-lspconfig) =============== --
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = { -- This will run mason-lspconfig.setup(opts)
            -- Ensure these servers are installed by Mason. Conform.nvim will use stylua if installed.
            ensure_installed = {
                "lua_ls",
                "pyright",
                "bashls",
            },
            -- automatic_installation = true, -- Default if ensure_installed is set
        },
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for LSP
        },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- Setup capabilities with nvim-cmp
            local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
            capabilities.textDocument.completion.completionItem.snippetSupport = true -- Enable snippet support

            local on_attach = function(client, bufnr)
                require("completion").on_attach()

                local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

                -- Mappings
                local opts = { noremap = true, silent = true }
                buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
                buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
                buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
                buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
                buf_set_keymap(
                    "n",
                    "<space>wl",
                    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                    opts
                )
                buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
                buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
                buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
                buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
                buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

                -- Set some keybinds conditional on server capabilities
                if client.resolved_capabilities.document_formatting then
                    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
                elseif client.resolved_capabilities.document_range_formatting then
                    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
                end
            end

            -- Configure lua_ls (Lua Language Server)
            vim.lsp.config("lua_ls", {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false, -- Can speed up indexing, set to true if needed
                        },
                        telemetry = { enable = false },
                        hint = { enable = true }, -- Enable inlay hints for Lua
                    },
                },
            })

            vim.lsp.config("mason-lspconfig", {
                -- Default handler for each server managed by mason-lspconfig
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                -- You can add custom handlers for specific servers if needed
                -- ["gopls"] = function() ... end,
            })

            -- Default handler for other servers installed via Mason (if any)
            -- This will apply the on_attach and capabilities to them.
            require("mason-lspconfig").setup()
        end,
    },

    -- ============== IV. Autocompletion (nvim-cmp) =============== --
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "windwp/nvim-autopairs", -- Autopairs is a nice companion
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
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
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        if vim.lsp.protocol and vim.lsp.protocol.get_kind_icons then
                            local icons = vim.lsp.protocol.get_kind_icons()
                            if icons and icons[vim_item.kind] then
                                vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
                            end
                        end
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buff]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                -- For nvim-autopairs integration
                experimental = {
                    ghost_text = false, -- or true, if you like it
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- nvim-autopairs integration with nvim-cmp
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- Snippet Engine
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Follow a major version for stability
        build = "make install_jsregexp", -- For regex
        dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: a nice collection of snippets
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load() -- Load snippets from friendly-snippets
        end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- dependencies = {"hrsh7th/nvim-cmp"}, -- Already handled by nvim-cmp's dependencies
        config = function()
            require("nvim-autopairs").setup({
                -- your autopairs config if needed
            })
            -- The cmp integration is handled in nvim-cmp's config
        end,
    },
}
