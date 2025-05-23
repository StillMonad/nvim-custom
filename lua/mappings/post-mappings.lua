vim.keymap.set("n", "<leader><Left>", "<cmd>BufferPrevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>h", "<cmd>BufferPrevious<CR>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader><Right>", "<cmd>BufferNext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>l", "<cmd>BufferNext<CR>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader><Up>", "<cmd>BufferMovePrevious<CR>", { desc = "Move tab left" })
vim.keymap.set("n", "<leader><Down>", "<cmd>BufferMoveNext<CR>", { desc = "Move tab right" })
vim.keymap.set("n", "<leader>x", "<cmd>BufferClose<CR>", { desc = "Close tab/buffer" })

vim.keymap.set("n", "<leader>tf", "<cmd>DiffviewFocusFiles<cr>", { desc = "[T]oggle [F]ile diff" })
vim.keymap.set("n", "<leader>ts", "<cmd>DiffviewOpen<cr>", { desc = "[T]oggle [S]plit diff on current file" })

-- vim.keymap.set("v", "<leader>aca", "<cmd>GpContext<cr>", { desc = "[A]I [C]ontext [A]dd" })
-- vim.keymap.set("n", "<leader>acc", "<cmd>!rm .gp.md<cr>", { desc = "[A]I [C]ontext [C]lear" })
-- vim.keymap.set("n", "<leader>aa", "<cmd>GpPopup<cr>", { desc = "[A]I [A]sk" })
-- Chat commands
-- vim.keymap.set({ "n", "i" }, "<leader>ac", "<cmd>GpChatNew<cr>", { desc = "New Chat" })
-- vim.keymap.set({ "n", "i" }, "<leader>at", "<cmd>GpChatToggle<cr>", { desc = "Toggle Chat" })
-- vim.keymap.set({ "n", "i" }, "<leader>af", "<cmd>GpChatFinder<cr>", { desc = "Chat Finder" })

-- vim.keymap.set("v", "<leader>ac", ":<C-u>'<,'>GpChatNew<cr>", { desc = "Visual Chat New" })
-- vim.keymap.set("v", "<leader>ap", ":<C-u>'<,'>GpChatPaste<cr>", { desc = "Visual Chat Paste" })
-- vim.keymap.set("v", "<leader>at", ":<C-u>'<,'>GpChatToggle<cr>", { desc = "Visual Toggle Chat" })

-- vim.keymap.set({ "n", "i" }, "<leader>a<C-x>", "<cmd>GpChatNew split<cr>", { desc = "New Chat split" })
-- vim.keymap.set({ "n", "i" }, "<leader>a<C-v>", "<cmd>GpChatNew vsplit<cr>", { desc = "New Chat vsplit" })
-- vim.keymap.set({ "n", "i" }, "<leader>a<C-t>", "<cmd>GpChatNew tabnew<cr>", { desc = "New Chat tabnew" })

-- vim.keymap.set("v", "<leader>a<C-x>", ":<C-u>'<,'>GpChatNew split<cr>", { desc = "Visual Chat New split" })
-- vim.keymap.set("v", "<leader>a<C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", { desc = "Visual Chat New vsplit" })
-- vim.keymap.set("v", "<leader>a<C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", { desc = "Visual Chat New tabnew" })
-- Prompt commands
-- vim.keymap.set({ "n", "i" }, "<leader>ar", "<cmd>GpRewrite<cr>", { desc = "Inline Rewrite" })
-- vim.keymap.set({ "n", "i" }, "<leader>aa", "<cmd>GpAppend<cr>", { desc = "Append (after)" })
-- vim.keymap.set({ "n", "i" }, "<leader>ab", "<cmd>GpPrepend<cr>", { desc = "Prepend (before)" })

-- vim.keymap.set("v", "<leader>ar", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Rewrite" })
-- vim.keymap.set("v", "<leader>aa", ":<C-u>'<,'>GpAppend<cr>", { desc = "Visual Append (after)" })
-- vim.keymap.set("v", "<leader>ab", ":<C-u>'<,'>GpPrepend<cr>", { desc = "Visual Prepend (before)" })
-- vim.keymap.set("v", "<leader>ai", ":<C-u>'<,'>GpImplement<cr>", { desc = "Implement selection" })

-- vim.keymap.set({ "n", "i" }, "<leader>agp", "<cmd>GpPopup<cr>", { desc = "Popup" })
-- vim.keymap.set({ "n", "i" }, "<leader>age", "<cmd>GpEnew<cr>", { desc = "GpEnew" })
-- vim.keymap.set({ "n", "i" }, "<leader>agn", "<cmd>GpNew<cr>", { desc = "GpNew" })
-- vim.keymap.set({ "n", "i" }, "<leader>agv", "<cmd>GpVnew<cr>", { desc = "GpVnew" })
-- vim.keymap.set({ "n", "i" }, "<leader>agt", "<cmd>GpTabnew<cr>", { desc = "GpTabnew" })

-- vim.keymap.set("v", "<leader>agp", ":<C-u>'<,'>GpPopup<cr>", { desc = "Visual Popup" })
-- vim.keymap.set("v", "<leader>age", ":<C-u>'<,'>GpEnew<cr>", { desc = "Visual GpEnew" })
-- vim.keymap.set("v", "<leader>agn", ":<C-u>'<,'>GpNew<cr>", { desc = "Visual GpNew" })
-- vim.keymap.set("v", "<leader>agv", ":<C-u>'<,'>GpVnew<cr>", { desc = "Visual GpVnew" })
-- vim.keymap.set("v", "<leader>agt", ":<C-u>'<,'>GpTabnew<cr>", { desc = "Visual GpTabnew" })

-- vim.keymap.set({ "n", "i" }, "<leader>ax", "<cmd>GpContext<cr>", { desc = "Toggle Context" })
-- vim.keymap.set("v", "<leader>ax", ":<C-u>'<,'>GpContext<cr>", { desc = "Visual Toggle Context" })

-- vim.keymap.set({ "n", "i", "v", "x" }, "<leader>as", "<cmd>GpStop<cr>", { desc = "Stop" })
-- vim.keymap.set({ "n", "i", "v", "x" }, "<leader>an", "<cmd>GpNextAgent<cr>", { desc = "Next Agent" })

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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map("K", vim.lsp.buf.hover, "Hover Documentation")

        -- Opens a popup with lsp warning on line under cursor.
        map("gK", vim.diagnostic.open_float, "Hover Warning")

        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map(
                "<leader>th",
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                "[T]oggle Inlay [H]ints"
            )
        end
    end,
})
