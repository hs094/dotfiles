vim.opt.ignorecase = true
-- Commands
vim.cmd ("set expandtab")
vim.cmd ("set tabstop=2")
vim.cmd ("set softtabstop=2")
vim.cmd ("set shiftwidth=2" )

-- Customize line number colors
vim.api.nvim_set_hl(1, "LineNr", { fg = "#A6ADC8" })         -- Default line numbers
vim.api.nvim_set_hl(1, "CursorLineNr", { fg = "#F5E0DC" })  -- Highlighted current line number
vim.api.nvim_set_hl(1, "CursorLine", { bg = "#2D3149" })  -- Background color for the current line

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Disable mouse mode
vim.o.mouse = ''

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.opt.clipboard = 'unnamedplus'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Concealer for Neorg
vim.o.conceallevel=2

vim.api.nvim_create_autocmd({"InsertEnter", "InsertLeave"}, {
    callback = function()
        if vim.fn.mode() == "i" then
            vim.opt.relativenumber = false  -- Absolute in insert mode
        else
            vim.opt.relativenumber = true   -- Relative in normal mode
        end
    end,
})
