-- TOOLING: COMPLETION, DIAGNOSTICS, FORMATTING

-- Manager for external tools (LSPs, linters, debuggers, formatters)
-- auto-install of those external tools
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
        { "williamboman/mason.nvim", opts = true },
        { "williamboman/mason-lspconfig.nvim", opts = true },
    },
    opts = {
        ensure_installed = {
            "stylua", -- Lua style
            "lua-language-server", -- Lua lsp
            "pyright", -- LSP for python
            "ruff", -- linter for python (includes flake8, pep8, etc.)
        },
    },
}
