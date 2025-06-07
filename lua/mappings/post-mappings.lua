vim.keymap.set("n", "<leader><Left>", "<cmd>BufferPrevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>h", "<cmd>BufferPrevious<CR>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader><Right>", "<cmd>BufferNext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>l", "<cmd>BufferNext<CR>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader><Up>", "<cmd>BufferMovePrevious<CR>", { desc = "Move tab left" })
vim.keymap.set("n", "<leader><Down>", "<cmd>BufferMoveNext<CR>", { desc = "Move tab right" })
vim.keymap.set("n", "<leader>x", "<cmd>BufferClose<CR>", { desc = "Close tab/buffer" })

vim.keymap.set("n", "<leader>tf", "<cmd>DiffviewFocusFiles<cr>", { desc = "[T]oggle [F]ile diff" })
vim.keymap.set("n", "<leader>ts", "<cmd>DiffviewOpen<cr>", { desc = "[T]oggle [S]plit diff on current file" })

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    group = vim.api.nvim_create_augroup("disable_statusline_on_inactive", {}),
    desc = "Disable status line on unfocused buffers",
    pattern = "*",
    callback = function() vim.b.ministatusline_disable = true end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = vim.api.nvim_create_augroup("disable_statusline_on_inactive", {}),
    desc = "Disable status line on unfocused buffers",
    pattern = "*",
    callback = function() vim.b.ministatusline_disable = false end,
})
