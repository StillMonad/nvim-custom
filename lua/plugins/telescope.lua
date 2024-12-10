return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    cmd = "Telescope",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Grep in files (find words)" },
        { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
}
