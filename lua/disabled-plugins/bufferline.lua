return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup({
            options = {
                auto_toggle_bufferline = true,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true, -- use a "true" to enable the default, or set your own character
                    },
                },
            },
        })
    end,
    lazy = false,
    keys = {
        { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
        { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Next tab" },
    },
}

