return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    cmd = "Telescope",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[F]ind [F]iles" },
        { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "[F]ind in files (find [W]ords)" },
        { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[F]ind [G]it files" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[F]ind [B]uffers" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "[F]ind [R]ecent" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
}
