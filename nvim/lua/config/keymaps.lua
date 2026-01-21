-- Core keymaps
vim.keymap.set('n', '<leader>l', function() vim.cmd('Lazy') end, { desc = 'Open/Close Lazy plugin manager' })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Copy line to system clipboard' })
-- Note: <leader>. is mapped to Snacks.scratch() in snacks.lua
-- To clear search highlights, press <Esc> (works by default) or use :noh

-- DAP Debugger Keymaps
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'DAP: Continue' })
vim.keymap.set('n', '<leader>dp', function() require('dap').pause() end, { desc = 'DAP: Pause' })
vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, { desc = 'DAP: Step Over' })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'DAP: Step Into' })
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc = 'DAP: Step Out' })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'DAP: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'DAP: Toggle UI' })
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'DAP: Open REPL' })
