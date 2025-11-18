return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
  },

  ---@module "auto-session"
  opts = {
    -- Auto-open neo-tree after session restore and change to session directory
    post_restore_cmds = {
      function(session_name)
        -- Simple URL decode for session names (auto-session uses %2F for /, %2E for .)
        local function simple_url_decode(str)
          if not str then return nil end
          return str:gsub("%%2F", "/"):gsub("%%2E", ".")
        end
        local session_path = simple_url_decode(session_name)
        if session_path and vim.fn.isdirectory(session_path) == 1 then
          vim.cmd("cd " .. vim.fn.fnameescape(session_path))
        end
        -- Open neo-tree to show the new directory
        vim.cmd("Neotree show")
      end,
    },
    session_lens = {
      picker = nil,
      mappings = {
        delete_session = { "i", "<C-d>" },
        alternate_session = { "i", "<C-s>" },
        copy_session = { "i", "<C-y>" },
      },
      load_on_setup = true,
    },
  },

  init = function()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}