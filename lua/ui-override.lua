
-- -- Custom UI override

-- function SetHighlight()
--     --  make comments brighter for dark themes
--     vim.api.nvim_set_hl(0, "Comment", { italic = true, fg = "#AAAAAA"  })
--     --  make highlights brighter for bright themes
--     vim.api.nvim_set_hl(0, "Visual", { bg = "#797979" })
--     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- end


-- vim.api.nvim_create_autocmd({"VimEnter", "ColorScheme"}, {
--     group = vim.api.nvim_create_augroup('Color', {}),
--     pattern = "*",
--     callback = SetHighlight
-- })