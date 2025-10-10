-- Basic vim settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

-- Load lazy.nvim configuration
require('config.lazy')

-- Keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
-- vim.keymap.set('n', '<leader>d', ':Dashboard<CR>', { desc = 'Open Dashboard' })
