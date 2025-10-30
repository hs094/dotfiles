-- Keymap configuration for Neovim
-- Centralized keymap management with proper descriptions and lazy loading support

local M = {}

-- Core keymaps (no dependencies)
M.core = function()
  -- Lazy.nvim
  vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { desc = 'Open/Close Lazy plugin manager' })
end

-- Telescope keymaps
M.telescope = function()
  if pcall(require, 'telescope.builtin') then
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-p>', builtin.find_files, {
      desc = 'Find files with Telescope'
    })
    vim.keymap.set('n', '<leader>rg', builtin.live_grep, {
      desc = 'Live grep with Telescope'
    })
  end
end

-- Neo-tree keymaps
-- M.neo_tree = function()
--   if pcall(require, 'neo-tree') then
--     vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { 
--       desc = 'Toggle Neo-tree file explorer' 
--     })
--     vim.keymap.set('n', '<leader>e', ':Neotree focus<CR>', { 
--       desc = 'Focus Neo-tree' 
--     })
--     vim.keymap.set('n', '<leader>o', ':Neotree filesystem reveal left<CR>', { 
--       desc = 'Open Neo-tree and reveal current file' 
--     })
--   end
-- end

-- LSP keymaps
M.lsp = function()
  if vim.lsp then
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { 
      desc = 'Show LSP hover information' 
    })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { 
      desc = 'Go to definition' 
    })
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { 
      desc = 'Show LSP code actions' 
    })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { 
      desc = 'Rename symbol with LSP' 
    })
  end
end

-- Formatting keymaps
M.formatting = function()
  if vim.lsp then
    vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {
      desc = 'Format code using LSP'
    })
  end
end

-- AI/Cursor agent keymaps
M.ai = function()
  if pcall(require, 'neovim-cursor') then
    vim.keymap.set('n', '<C-a>', ':CursorAgent<CR>', {
      desc = 'Toggle Cursor AI agent terminal'
    })
    vim.keymap.set('v', '<C-a>', ':CursorAgent<CR>', {
      desc = 'Toggle Cursor AI agent and send selection'
    })
  end
end

-- Copilot keymaps
M.copilot = function()
  if vim.g.copilot_no_tab_map ~= false then
    -- These are set up in the plugin config, but we can add additional ones here if needed
    vim.keymap.set('n', '<leader>cp', ':Copilot status<CR>', {
      desc = 'Show Copilot status'
    })
    vim.keymap.set('n', '<leader>cps', ':Copilot panel<CR>', {
      desc = 'Open Copilot panel'
    })
  end
end

-- Load all keymaps with safety checks
M.load_all = function()
  M.core()
  M.telescope()
  --  M.neo_tree()
  M.lsp()
  M.formatting()
  M.ai()
  M.copilot()
end

-- Auto-load keymaps
M.load_all()
vim.api.nvim_set_keymap('n', '<Leader>/', ':noh<CR>', { noremap = true, silent = true })
return M
