return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- core
        highlight = {
          enable = true,
          disable = { "help" }, -- must be a list
        },
        indent = { enable = true },

        -- parsers
        auto_install = true,      -- needs tree-sitter CLI on PATH
        sync_install = false,
        ensure_installed = {
          "vim", "vimdoc", "lua", "luadoc", "markdown",
          "html", "css", "python", "php", "javascript", "typescript",
          "query", -- recommended for textobjects queries
        },

        -- selections (expand/shrink)
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },

        -- TEXTOBJECTS
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- jump forward to nearest textobject
            keymaps = {
              -- functions
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              -- classes
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- conditionals / loops
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              -- parameters/arguments
              ["ap"] = "@parameter.outer",
              ["ip"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}

