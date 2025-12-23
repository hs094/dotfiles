-- Core keymaps
vim.keymap.set('n', '<leader>l', function() vim.cmd('Lazy') end, { desc = 'Open/Close Lazy plugin manager' })
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Copy line to system clipboard' })
-- Note: <leader>. is mapped to Snacks.scratch() in snacks.lua
-- To clear search highlights, press <Esc> (works by default) or use :noh