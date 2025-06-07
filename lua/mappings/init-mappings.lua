-- keymaps/macros
local map = vim.keymap.set

-- handy keymaps
-- map("n", "<leader>x", ":bd<CR>:bp<CR>")
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")
map("n", "g#", "g#zz")

map("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move selected block down" })
map("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move selected block up" })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selected block down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selected block up" })
map("n", "<C-j>", "<cmd>:m +1<CR>", { noremap = true, silent = true, desc = "Move selected block down" })
map("n", "<C-k>", "<cmd>:m -2<CR>", { noremap = true, silent = true, desc = "Move selected block up" })

map("i", "<C-l>", "<Esc>>>i", { noremap = true, silent = true, desc = "Move selected block right" })
map("i", "<C-h>", "<Esc><<i", { noremap = true, silent = true, desc = "Move selected block left" })
map("v", "<C-l>", ">gv", { noremap = true, silent = true, desc = "Move selected block right" })
map("v", "<C-h>", "<gv", { noremap = true, silent = true, desc = "Move selected block left" })
map("n", "<C-h>", "<<gv", { noremap = true, silent = true, desc = "Move selected block right" })
map("n", "<C-l>", ">>gv", { noremap = true, silent = true, desc = "Move selected block left" })

map("n", ",", "@@", { noremap = true, silent = true, desc = "Repeat previous macro" })

map("n", "<leader>w<Left>", "<C-w>h", { noremap = true, silent = true, desc = "[W]indow: focus left" })
map("n", "<leader>w<Right>", "<C-w>l", { noremap = true, silent = true, desc = "[W]indow: focus right" })
map("n", "<leader>w<Down>", "<C-w>j", { noremap = true, silent = true, desc = "[W]indow: focus down" })
map("n", "<leader>w<Up>", "<C-w>k", { noremap = true, silent = true, desc = "[W]indow: focus up" })

map("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "which_key_ignore" })
map("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "which_key_ignore" })
map("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "which_key_ignore" })
map("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "which_key_ignore" })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 }) end,
})

-- copy default reg to/from system/mouse clipboard
-- map("v", 'y', '+y')
-- map("v", 'yy', '+yy')
