return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
  },
  config = function()
      require("neo-tree").setup({
          filesystem = {
              filtered_items = {
                  visible = true, -- Show hidden files
                  hide_dotfiles = false, -- Do not hide dotfiles
                  hide_gitignored = false, -- Show git-ignored files
                  hide_by_name = { ".git" }, -- Exclude .git folders
              }
          }
      })

      -- Function to toggle Neo-tree
      local function toggle_neotree()
          local winid = vim.fn.bufwinid("Neo-tree filesystem [1]")  -- Get Neo-tree window ID
          if winid ~= -1 then
              vim.cmd("Neotree close")  -- Close if open
          else
              vim.cmd("Neotree toggle") -- Toggle visibility
          end
      end

      -- Keybinding to toggle Neo-tree
      vim.keymap.set('n', '<C-n>', toggle_neotree, { silent = true, noremap = true })
  end
}