local pre_prompt = [[
You are an experienced coder, specializing in Python, Rust, and TypeScript.
- Respond with working, type-annotated code.
- Use modern language features (Python 3.10+, Rust 2021).
- Return only code snippets without additional explanation unless explicitly asked.
]]

return {
    "robitx/gp.nvim",
    config = function()
        local conf = {
            -- For customization, refer to Install > Configuration in the Documentation/Readme
            providers = {
                openai = { disable = true },
                azure = { disable = true },
                copilot = { disable = true },
                lmstudio = { disable = true },
                googleai = { disable = true },
                pplx = { disable = true },
                anthropic = { disable = true },
                ollama = {
                    disable = false,
                    endpoint = "http://localhost:11434/v1/chat/completions",
                    options = {
                        timeout = 300000, -- 5 minutes (in milliseconds)
                        stream = true, -- Required for long responses
                    },
                },
            },
            agents = {
                {
                    provider = "ollama",
                    name = "qwen2.5-coder:14b",
                    chat = true,
                    command = true,
                    model = {
                        model = "qwen2.5-coder:14b",
                    },
                    system_prompt = pre_prompt,
                },
                {
                    provider = "ollama",
                    name = "qwen2.5-coder:7b",
                    chat = true,
                    command = true,
                    model = {
                        model = "qwen2.5-coder:7b",
                    },
                    system_prompt = pre_prompt,
                },
                {
                    provider = "ollama",
                    name = "qwen2.5-coder:3b",
                    chat = true,
                    command = true,
                    model = {
                        model = "qwen2.5-coder:3b",
                    },
                    system_prompt = pre_prompt,
                },
                {
                    provider = "ollama",
                    name = "mistral",
                    chat = true,
                    command = true,
                    model = {
                        model = "mistral:latest",
                    },
                    system_prompt = pre_prompt,
                },
                {
                    provider = "ollama",
                    name = "deepseek-coder-v2",
                    chat = true,
                    command = true,
                    model = {
                        model = "deepseek-coder-v2:16b",
                    },
                    system_prompt = pre_prompt,
                },
                {
                    provider = "ollama",
                    name = "codestral",
                    chat = true,
                    command = true,
                    model = {
                        model = "codestral:latest",
                    },
                    system_prompt = pre_prompt,
                },
                {
                    provider = "ollama",
                    name = "phi3",
                    chat = true,
                    command = true,
                    model = {
                        model = "phi3:medium-128k",
                    },
                    system_prompt = pre_prompt,
                },
            },
        }
        require("gp").setup(conf)
    end,
}
