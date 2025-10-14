local ts_select_dir_for_grep = function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local fb = require("telescope").extensions.file_browser
    local live_grep = require("telescope.builtin").live_grep
    local current_line = action_state.get_current_line()

    fb.file_browser({
        files = false,
        depth = false,
        attach_mappings = function(prompt_bufnr)
            require("telescope.actions").select_default:replace(function()
                local entry_path = action_state.get_selected_entry().Path
                local dir = entry_path:is_dir() and entry_path or entry_path:parent()
                local relative = dir:make_relative(vim.fn.getcwd())
                local absolute = dir:absolute()

                live_grep({
                    results_title = relative .. "/",
                    cwd = absolute,
                    default_text = current_line,
                })
            end)

            return true
        end,
    })
end

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
        { "C-n", function() require("misc.telescope_cycle").next() end, "[C]ycle pickers" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        require("telescope").setup({
            pickers = {
                live_grep = {
                    mappings = {
                        i = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                        n = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                    },
                    hidden = true,
                },
            },
            extensions = { fzf = {} },
        })

        require("telescope").load_extension("fzf")
    end,
}
