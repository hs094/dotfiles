-- Fix neo-tree window ID issues during plugin updates
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    if package.loaded["neo-tree"] then
      -- Safely check state without throwing errors on invalid window IDs
      local ok = pcall(function()
        require("neo-tree.sources.manager").get_state("filesystem")
      end)
      if not ok then
        -- Silently continue if window ID is invalid
        return
      end
    end
  end,
})