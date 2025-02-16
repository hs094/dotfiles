vim.cmd ("set expandtab") 
vim.cmd ("set tabstop=2" ) 
vim.cmd ("set softtabstop=2") 
vim.cmd ("set shiftwidth=2" ) 
vim.g.mapleader = " "
-- Customize line number colors
vim.api.nvim_set_hl(0, "LineNr", { fg = "#A6ADC8" })         -- Default line numbers
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#F5E0DC" })  -- Highlighted current line number
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2D3149" })  -- Background color for the current line

vim.api.nvim_create_autocmd({"InsertEnter", "InsertLeave"}, {
    callback = function()
        if vim.fn.mode() == "i" then
            vim.opt.relativenumber = false  -- Absolute in insert mode
        else
            vim.opt.relativenumber = true   -- Relative in normal mode
        end
    end,
})

