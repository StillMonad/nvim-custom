return {
    {
        "alexpasmantier/pymple.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- optional (nicer ui)
            "stevearc/dressing.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        build = ":PympleBuild",
        config = function()
            require("pymple").setup()
            local project = require("pymple.project")
            project.root = vim.fn.getcwd() -- or hardcode absolute repo root,
        end, -- Force project root to repository root (parent of `src/`)
    },
}
