return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
    config =  function()
      require("nvim-tree").setup({
        view = {
          width = 60,
        },
	update_focused_file = {
	  enable = true,
	}
      })
    end
  }
}
