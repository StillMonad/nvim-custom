-- keymaps/macros
local map = vim.keymap.set

-- handy keymaps
-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("n", "<leader>x", ":bd<CR>:bp<CR>")

-- move code blocks in visual mode with indenting
-- up/down
map("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi", { noremap = true, silent = true })
map("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi", { noremap = true, silent = true })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("n", "<C-j>", "<cmd>:m +1<CR>", { noremap = true, silent = true })
map("n", "<C-k>", "<cmd>:m -2<CR>", { noremap = true, silent = true })

-- left/right
map("i", "<c-l>", "<Esc>>>i", { noremap = true, silent = true })
map("i", "<c-h>", "<Esc><<i", { noremap = true, silent = true })
map("v", "<C-l>", ">gv", { noremap = true, silent = true })
map("v", "<C-h>", "<gv", { noremap = true, silent = true })
map("n", "<C-h>", "<<", { noremap = true, silent = true })
map("n", "<C-l>", ">>", { noremap = true, silent = true })

-- copy default reg to/from system/mouse clipboard
-- map("v", 'y', '+y')
-- map("v", 'yy', '+yy')
-- delete previous word on CTRL-Delete
map("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })
-- repeat previous macros
map("n", ",", "@@", { noremap = true, silent = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 }) end,
})
