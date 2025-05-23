-- ~/.config/nvim/init.lua

-- --- Configuration ---
-- IMPORTANT: Replace "com.apple.keylayout.US" with your actual English layout ID
local english_layout_id = "com.apple.keylayout.ABC" -- <-- REPLACE THIS!

-- Global flags to control behavior (defaults are set if not already defined)
-- Enable/disable the main feature of switching to English in Normal/Cmd mode
vim.g.auto_english_default_enabled = vim.g.auto_english_default_enabled == nil and true
    or vim.g.auto_english_default_enabled
-- Enable/disable restoring the last used (non-English) layout when entering Insert mode
vim.g.auto_english_restore_insert_layout = vim.g.auto_english_restore_insert_layout == nil and false
    or vim.g.auto_english_restore_insert_layout

-- Script-local variable to store the last used non-English layout in Insert mode
local s_last_insert_layout = nil
-- --- End Configuration ---

local function im_select_is_available()
    if vim.fn.executable("im-select") == 0 then
        vim.notify(
            "im-select command not found. Please ensure it's installed and in your PATH.",
            vim.log.levels.WARN,
            { title = "Layout Manager" }
        )
        return false
    end
    return true
end

local function switch_to_layout(layout_id)
    if not im_select_is_available() then return end

    local current_layout = vim.fn.trim(vim.fn.system("im-select"))
    if current_layout ~= layout_id and current_layout ~= "" then
        vim.fn.jobstart({ "im-select", layout_id }, { detach = true })
    end
end

local group = vim.api.nvim_create_augroup("AutoKeyboardLayout", { clear = true })

-- Switch to English when leaving Insert mode (entering Normal mode)
vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    pattern = "*",
    callback = function()
        if not vim.g.auto_english_default_enabled then return end

        if vim.g.auto_english_restore_insert_layout then
            if not im_select_is_available() then return end
            local layout_in_insert = vim.fn.trim(vim.fn.system("im-select"))
            if layout_in_insert ~= english_layout_id and layout_in_insert ~= "" then
                s_last_insert_layout = layout_in_insert
            -- vim.notify("Stored for Insert: " .. s_last_insert_layout, vim.log.levels.INFO, {title="Layout"}) -- For debugging
            else
                s_last_insert_layout = nil -- Clear if Insert mode was English
            end
        end
        switch_to_layout(english_layout_id)
    end,
})

-- Switch to English when entering Command-line mode
vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = group,
    pattern = "*",
    callback = function()
        if not vim.g.auto_english_default_enabled then return end
        switch_to_layout(english_layout_id)
    end,
})

-- Restore layout (if enabled and stored) when entering Insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    pattern = "*",
    callback = function()
        -- We only restore if the main feature is on, and the restore sub-feature is on
        if not vim.g.auto_english_default_enabled or not vim.g.auto_english_restore_insert_layout then return end

        if s_last_insert_layout then
            -- vim.notify("Restoring for Insert: " .. s_last_insert_layout, vim.log.levels.INFO, {title="Layout"}) -- For debugging
            switch_to_layout(s_last_insert_layout)
        end
    end,
})

-- Switch to English when Neovim starts (if not in insert/terminal mode)
vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    pattern = "*",
    callback = function()
        if not vim.g.auto_english_default_enabled then return end
        local current_mode = vim.fn.mode()
        if not (current_mode:match("^[iR]") or current_mode == "t") then switch_to_layout(english_layout_id) end
    end,
})

-- Custom commands to toggle the features
vim.api.nvim_create_user_command("ToggleAutoEnglish", function()
    vim.g.auto_english_default_enabled = not vim.g.auto_english_default_enabled
    local status = vim.g.auto_english_default_enabled and "Enabled" or "Disabled"
    vim.notify("Automatic English in Normal/Cmd mode: " .. status, vim.log.levels.INFO, { title = "Layout Manager" })
end, {})

vim.api.nvim_create_user_command("ToggleRestoreInsertLayout", function()
    vim.g.auto_english_restore_insert_layout = not vim.g.auto_english_restore_insert_layout
    local status = vim.g.auto_english_restore_insert_layout and "Enabled" or "Disabled"
    vim.notify("Restore last Insert mode layout: " .. status, vim.log.levels.INFO, { title = "Layout Manager" })
    if not vim.g.auto_english_restore_insert_layout then
        s_last_insert_layout = nil -- Clear any stored layout when disabling this feature
    end
    if vim.g.auto_english_restore_insert_layout and not vim.g.auto_english_default_enabled then
        vim.notify(
            "Note: Main 'AutoEnglish' feature is currently disabled.",
            vim.log.levels.WARN,
            { title = "Layout Manager" }
        )
    end
end, {})

vim.notify(
    string.format(
        "Keyboard layout manager loaded. AutoEnglish: %s, RestoreInsert: %s",
        tostring(vim.g.auto_english_default_enabled),
        tostring(vim.g.auto_english_restore_insert_layout)
    ),
    vim.log.levels.INFO,
    { title = "Layout Manager" }
)
