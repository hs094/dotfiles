return {
    "catppuccin/nvim",
    lazy = false, -- Load during startup
    name = "catppuccin", -- Corrected the name spelling
    priority = 1000, -- Ensure it loads first for proper theming
    config = function()
        -- Setup Catppuccin with your preferred flavor (latte, frappe, macchiato, mocha)
        require("catppuccin").setup({
            flavour = "mocha", -- Change this to your preferred flavor
            integrations = {
                treesitter = true,
                native_lsp = { enabled = true },
                lsp_trouble = true,
                telescope = true,
                which_key = true,
            },
        })

        -- Apply the colorscheme
        vim.cmd.colorscheme("catppuccin")
    end,
}
