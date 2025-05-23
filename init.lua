-- LEADER key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd("set keymap=russian-typograph")
vim.opt.iminsert = 0
vim.opt.imsearch = -1
-- some preferences
vim.cmd("set relativenumber")
vim.cmd("set nowrap")
vim.cmd("set formatoptions-=t")
vim.cmd("set guioptions+=b")
vim.cmd("set lazyredraw")
vim.cmd("set tabstop=4 shiftwidth=4 smarttab expandtab tabstop=8 softtabstop=0")
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
-- vim.opt.scrolloff = 999
-- vim.opt.nostartofline = true
vim.opt.number = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
require("mappings.keep-eng-in-normal")
require("mappings.init-mappings")
require("lazy-init")
require("mappings.post-mappings")
require("ui-override")

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--     -- delay update diagnostics
--     update_in_insert = true,
-- })
--
