return {
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Spectre",
        keys = {},
        config = function()
            require("spectre").setup({
                default = {
                    replace = {
                        cmd = "oxi", -- 👈 use oxi-cli instead of sed
                    },
                },
            })
        end,
    },
}
