-- Basic vim settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true                     -- Enable true colors
vim.opt.cursorline = true                        -- Highlight current line
vim.opt.wrap = false                             -- Disable line wrapping
vim.opt.scrolloff = 8                            -- Keep 8 lines above and below the cursor
vim.opt.sidescrolloff = 8                        -- Keep 8 columns to the left and right of the cursor
vim.opt.ignorecase = true                        -- Case insensitive searching
vim.opt.smartcase = true                         -- Case sensitive if uppercase letters are used
vim.opt.updatetime = 300                         -- Faster completion
vim.opt.signcolumn = "yes"                       -- Always show sign column

-- Load keymaps
require('config.keymaps')

-- Load lazy.nvim configuration
require('config.lazy')
