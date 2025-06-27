return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
        },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 45,
                },
                update_focused_file = {
                    enable = true,
                },
                renderer = {
                    icons = {
                        show = {
                            file = false,
                            folder = true,
                            folder_arrow = true,
                            hidden = true,
                        },
                        git_placement = "after",
                    },
                    indent_markers = {
                        enable = true,
                    },
                },
            })
        end,
    },
}
