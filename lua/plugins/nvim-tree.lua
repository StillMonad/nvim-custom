return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
        },
        -- opts = function(_, opts)
        --     local api = require("pymple.api")
        --     local config = require("pymple.config")
        --
        --     local function on_move(args)
        --         api.update_imports(args.source, args.destination, config.user_config.update_imports)
        --     end
        --
        --     local events = require("neo-tree.events")
        --     opts.event_handlers = opts.event_handlers or {}
        --     vim.list_extend(opts.event_handlers, {
        --         { event = events.FILE_MOVED, handler = on_move },
        --         { event = events.FILE_RENAMED, handler = on_move },
        --     })
        -- end,
        config = function()
            require("nvim-tree").setup({
                actions = { open_file = { quit_on_open = true } },
                view = {
                    width = 999,
                },
                update_focused_file = {
                    enable = true,
                },
                git = {
                    enable = true,
                },
                renderer = {
                    highlight_git = true,
                    icons = {
                        show = {
                            git = true,
                            file = true,
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
