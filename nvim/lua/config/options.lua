-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.wrap = true
vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"
vim.opt.foldmethod = "manual"

-- Disable LazyFormat auto-format on save by default. Use :LazyFormat for manual formatting.
vim.g.autoformat = false
