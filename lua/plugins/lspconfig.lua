-- lua/custom/plugins/core_dev_setup.lua
-- Minimal LSP, Formatter, and Completion setup.
-- This file is fully corrected and modernized.

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
        -- This plugin is configured in the nvim-lspconfig section below.
        -- We just need to ensure it's loaded.
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for LSP
        },
        config = function()
            -- Get capabilities from nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            --             ROBUST ON_ATTACH VIA AUTOCMD
            --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                desc = "Setup buffer-local LSP keymaps",
                callback = function(ev)
                    local bufnr = ev.buf
                    local function set_keymap(mode, lhs, rhs, desc)
                        local opts = { noremap = true, silent = false, buffer = bufnr, desc = desc }
                        vim.keymap.set(mode, lhs, rhs, opts)
                    end

                    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
                    set_keymap("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    set_keymap("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                    set_keymap("n", "K", vim.lsp.buf.hover, "[K]eyword Hover")
                    set_keymap("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
                    set_keymap("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
                    set_keymap("n", "<C-k>", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
                    set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    set_keymap("n", "<leader>cD", vim.lsp.buf.type_definition, "[T]ype [D]efinition")
                    set_keymap("n", "<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
                    set_keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
                    set_keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
                    set_keymap(
                        "n",
                        "<leader>lwl",
                        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
                        "[W]orkspace [L]ist Folders"
                    )
                    set_keymap("n", "<leader>cd", vim.diagnostic.open_float, "[L]ine [D]iagnostics")
                    set_keymap("n", "<leader>cl", vim.diagnostic.setloclist, "[L]ocation [L]ist Diagnostics")
                    set_keymap("n", "<leader>cn", vim.diagnostic.goto_next, "[N]ext [D]iagnostic")
                    set_keymap("n", "<leader>cp", vim.diagnostic.goto_prev, "[P]revious [D]iagnostic")
                    set_keymap("n", "[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
                    set_keymap("n", "]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
                end,
            })

            --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            --                           SERVER SETUP
            -- This section is refactored to prevent duplicate server attachments.
            --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")

            local servers = { "lua_ls", "pyright", "bashls" }

            mason_lspconfig.setup({
                automatic_enable = true,
                ensure_installed = servers,
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = { version = "LuaJIT" },
                                    diagnostics = { globals = { "vim" } },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false,
                                    },
                                    telemetry = { enable = false },
                                    hint = { enable = true },
                                },
                            },
                        })
                    end,
                },
            })
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
                experimental = {
                    ghost_text = false,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- Snippet Engine
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup({}) end,
    },
}
