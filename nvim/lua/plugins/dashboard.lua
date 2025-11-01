return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      -- config
      vim.keymap.set('n', '<leader>db', '<cmd>Dashboard<CR>', { noremap = true, silent = true, desc = 'Open Dashboard' } )
    }
  end,
  requires = {'nvim-tree/nvim-web-devicons'}
}
