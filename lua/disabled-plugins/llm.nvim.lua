return {
    "huggingface/llm.nvim",
    enabled = true,
    -- event = "VeryLazy",
    opts = {
        backend = "ollama",
        model = "qwen2.5-coder:1.5b-instruct-q8_0",
        accept_keymap = "<Tab>",
        url = "http://localhost:11434", -- llm uses /api/generate
        request_body = {
            options = {
                temperature = 0.01,
                top_p = 0.8,
                max_tokens = 100,
            },
        },
        fim = { -- qwen-coder
            enabled = true,
            prefix = "<|fim_prefix|>",
            middle = "<|fim▁middle|>",
            suffix = "<|fim▁suffix|>",
        },
        tls_skip_verify_insecure = false,
        debounce_ms = 100,
        enable_suggestions_on_startup = true,
        -- enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
        disable_url_path_completion = false, -- cf Backend
        lsp = {
            bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
        },
    },
}
