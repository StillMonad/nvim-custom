return {
    "goolord/alpha-nvim",
    lazy = true, -- Can be lazy-loaded as it's only for the startup screen
    dependencies = {
        "echasnovski/mini.icons",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- All of your dashboard configuration now lives here, which is the correct
        -- location for a lazy.nvim setup.
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[                _                      _                _           _         _            _               _   _ _       ]],
            [[               / /\                   / /\             / /\        / /\    _ / /\         / /\            / / / / / _    ]],
            [[              /  \ \  ____           /  \ \           /  \ \       \ \ \  /_/ / /         \ \ \          / / / / // / /  ]],
            [[             / /\ \ \/  / /         / /\ \ \         / /\ \ \       \ \ \ \___\/          /\ \_\        /\ \/ \ \/ / /   ]],
            [[            / / /\ \___/ /         / / /\ \_\       / / /\ \ \      / / /  \ \ \         / /\/_/       /  \____\__/ /    ]],
            [[           / / /  \/____/         / /_/_ \/_/      / / /  \ \_\     \ \ \   \_\ \       / / /         / /\/________/     ]],
            [[          / / /    / / /         / /____/\        / /     / / /      \ \ \  / / /      / / /         / / /\/_// / /      ]],
            [[         / / /    / / /         / /\____\/       / / /   / / /        \ \ \/ / /      / / /         / / /    / / /       ]],
            [[        / / /    / / /         / / /______      / / /___/ / /          \ \ \/ /   ___/ / /__       / / /    / / /        ]],
            [[       / / /    / / /         / / /_______\    / / /____\/ /            \ \  /   /\__\/_/___\      \/_/    / / /         ]],
            [[       \/_/     \/_/          \/__________/    \/_________/              \_\/    \/_________/              \/_/          ]],
            [[                                                                                                                         ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button( "ff", "  Find file",           ":Telescope find_files <CR>"                 ),
            dashboard.button( "e",  "  New file",            ":ene <BAR> startinsert <CR>"                ),
            dashboard.button( "fr", "  Recently used files", ":Telescope oldfiles <CR>"                   ),
            dashboard.button( "fw", "  Find text",           ":Telescope live_grep <CR>"                  ),
            dashboard.button( "c",  "  Configuration",       ":e ~/.config/nvim/nvim-custom/init.lua<CR>" ),
            dashboard.button( "q",  "  Quit Neovim",         ":qa<CR>"                                    ),
        }

        local function footer() return "..." end

        dashboard.section.footer.val = footer()

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true
        require("alpha").setup(dashboard.opts)
    end,
}
