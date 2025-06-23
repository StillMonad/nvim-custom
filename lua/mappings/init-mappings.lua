-- keymaps/macros
local map = vim.keymap.set

-- Center screen on search and jumps
map("n", "n", "nzz", { desc = "Next search result (centered)" })
map("n", "N", "Nzz", { desc = "Previous search result (centered)" })
map("n", "*", "*zz", { desc = "Search for word under cursor (centered)" })
map("n", "#", "#zz", { desc = "Search for word under cursor (centered, reverse)" })
map("n", "g*", "g*zz", { desc = "Search for word under cursor (centered, no boundary)" })
map("n", "g#", "g#zz", { desc = "Search for word under cursor (centered, reverse, no boundary)" })

-- Move lines up/down in any mode
map("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move line down" })
map("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move line up" })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })
map("n", "<C-j>", "<cmd>:m .+1<CR>", { noremap = true, silent = true, desc = "Move line down" })
map("n", "<C-k>", "<cmd>:m .-2<CR>", { noremap = true, silent = true, desc = "Move line up" })

-- Indent/un-indent lines
map("i", "<C-l>", "<Esc>>>i", { noremap = true, silent = true, desc = "Indent line" })
map("i", "<C-h>", "<Esc><<i", { noremap = true, silent = true, desc = "Un-indent line" })
map("v", "<C-l>", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
map("v", "<C-h>", "<gv", { noremap = true, silent = true, desc = "Un-indent selection" })
map("n", "<C-h>", "<<", { noremap = true, silent = true, desc = "Un-indent line" })
map("n", "<C-l>", ">>", { noremap = true, silent = true, desc = "Indent line" })

-- Repeat last macro
map("n", ",", "@@", { noremap = true, silent = true, desc = "Repeat previous macro" })

-- Window management keymaps grouped under <leader>w
map("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "[H]orizontal split focus left" })
map("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "[V]ertical split focus right" })
map("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "[H]orizontal split focus down" })
map("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "[V]ertical split focus up" })
map("n", "<leader>w-", "<C-w>s", { noremap = true, silent = true, desc = "Split [H]orizontally" })
map("n", "<leader>w|", "<C-w>v", { noremap = true, silent = true, desc = "Split [V]ertically" })
map("n", "<leader>w=", "<C-w>=", { noremap = true, silent = true, desc = "Make splits [E]qual" })
map("n", "<leader>wx", "<cmd>close<CR>", { noremap = true, silent = true, desc = "Close current split" })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    desc = "Highlight selection on yank",
    pattern = "*",
    callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 }) end,
})
