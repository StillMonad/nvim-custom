-- -- Custom UI override
vim.opt.fillchars = {
    vert = "│", -- alternatives ▕
    fold = " ",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
    stlnc = " ",
    stl = " ",
}

vim.cmd.colorscheme("cyberdream")

-- alpha-config.lua

local status_ok, alpha = pcall(require, "alpha")
if not status_ok then return end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
    [[           _                   _               _        _          _            _             _   _        ]],
    [[          /\ \     _          /\ \            /\ \     /\ \    _ / /\          /\ \          /\_\/\_\ _    ]],
    [[         /  \ \   /\_\       /  \ \          /  \ \    \ \ \  /_/ / /          \ \ \        / / / / //\_\  ]],
    [[        / /\ \ \_/ / /      / /\ \ \        / /\ \ \    \ \ \ \___\/           /\ \_\      /\ \/ \ \/ / /  ]],
    [[       / / /\ \___/ /      / / /\ \_\      / / /\ \ \   / / /  \ \ \          / /\/_/     /  \____\__/ /   ]],
    [[      / / /  \/____/      / /_/_ \/_/     / / /  \ \_\  \ \ \   \_\ \        / / /       / /\/________/    ]],
    [[     / / /    / / /      / /____/\       / / /   / / /   \ \ \  / / /       / / /       / / /\/_// / /     ]],
    [[    / / /    / / /      / /\____\/      / / /   / / /     \ \ \/ / /       / / /       / / /    / / /      ]],
    [[   / / /    / / /      / / /______     / / /___/ / /       \ \ \/ /    ___/ / /__     / / /    / / /       ]],
    [[  / / /    / / /      / / /_______\   / / /____\/ /         \ \  /    /\__\/_/___\    \/_/    / / /        ]],
    [[  \/_/     \/_/       \/__________/   \/_________/           \_\/     \/_________/            \/_/         ]],
    [[                                                                                                           ]],
}

dashboard.section.buttons.val = {
    dashboard.button("ff", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("fr", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("fw", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  Configuration", ":e ~/.config/nvim/nvim-custom/init.lua<CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer() return "..." end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)

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
