--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
--             ROBUST ON_ATTACH VIA AUTOCMD
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- This autocmd reliably sets up buffer-local keymaps for LSP features.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    desc = "Setup buffer-local LSP keymaps",
    callback = function(ev)
        local bufnr = ev.buf
        local function set_keymap(mode, lhs, rhs, desc)
            local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        set_keymap("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        set_keymap("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        set_keymap("n", "K", vim.lsp.buf.hover, "[K]eyword Hover")
        set_keymap("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        set_keymap("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        set_keymap("n", "<C-k>", vim.lsp.buf.signature_help, "[S]ignature [H]elp")

        -- Mappings grouped under <leader>c for "Code"
        set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, "[A]ction")
        set_keymap("n", "<leader>cD", vim.lsp.buf.type_definition, "[T]ype [D]efinition")
        set_keymap("n", "<leader>cr", vim.lsp.buf.rename, "[R]ename")
        set_keymap("n", "<leader>cd", vim.diagnostic.open_float, "[L]ine [D]iagnostics")
        set_keymap("n", "<leader>cl", vim.diagnostic.setloclist, "[L]ocation [L]ist")
        set_keymap("n", "<leader>cn", vim.diagnostic.goto_next, "[N]ext [D]iagnostic")
        set_keymap("n", "<leader>cp", vim.diagnostic.goto_prev, "[P]revious [D]iagnostic")
    end,
})

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
--             LSP Info Autocommand
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
vim.api.nvim_create_user_command('LspConfig', function()
    print(vim.inspect(vim.lsp.get_active_clients()))
end, { desc = "Print active LSP client configurations" })

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
--             CONFORM FILE FORMATING
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         require("conform").format({ bufnr = args.buf })
--     end,
-- })
vim.keymap.set(
    "n",
    "<leader>cf",
    function() require("conform").format({ async = true, lsp_fallback = true }) end,
    { desc = "[C]ode [F]ormat" }
)
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
--             PLUGIN KEYMAPPINGS
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--

-- Barbar.nvim (Buffer/Tab management) grouped under <leader>b
vim.keymap.set("n", "<leader>h", "<cmd>BufferPrevious<CR>", { desc = "Previous [B]uffer" })
vim.keymap.set("n", "<leader>l", "<cmd>BufferNext<CR>", { desc = "Next [B]uffer" })
vim.keymap.set("n", "<leader>bH", "<cmd>BufferMovePrevious<CR>", { desc = "Move [B]uffer Left" })
vim.keymap.set("n", "<leader>bL", "<cmd>BufferMoveNext<CR>", { desc = "Move [B]uffer Right" })
vim.keymap.set("n", "<leader>bx", "<cmd>BufferClose<CR>", { desc = "Close [B]uffer" })

-- Diffview.nvim (Git diff tool) grouped under <leader>g for "Git"
vim.keymap.set("n", "<leader>go", "<cmd>DiffviewOpen<cr>", { desc = "[O]pen Diffview" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "[C]lose Diffview" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File [H]istory" })

-- Terminal Keymaps for Toggleterm
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
