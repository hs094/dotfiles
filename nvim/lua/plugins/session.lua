-- Helper function to URL-decode a string (percent decoding)
-- Converts %2F to /, %2E to ., etc.
local function url_decode(str)
  if not str then
    return nil
  end
  -- Try using vim.fn.urldecode if available (in newer Neovim versions)
  if vim.fn.exists("*urldecode") == 1 then
    return vim.fn.urldecode(str)
  end
  -- Manual URL decoding: replace %XX with corresponding character
  return str:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
end

-- Helper function to extract directory from session name
-- Session names are URL-encoded directory paths (e.g., %2FUsers%2Fhs094%2FDev%2Ehs%2FChaosTrack)
-- The session name IS the directory path, just URL-encoded
local function get_session_dir(session_name)
  if not session_name or session_name == "" then
    return nil
  end
  -- Try to decode the session name as URL-encoded path
  -- auto-session uses percent encoding for paths
  local decoded = url_decode(session_name)
  -- The decoded session name should be the directory path
  -- Check if it's a valid directory
  if decoded and vim.fn.isdirectory(decoded) == 1 then
    return decoded
  end
  -- If decoding didn't work directly, try getting the directory from the session file
  local root_dir = vim.fn.stdpath("data") .. "/sessions/"
  local session_file = root_dir .. session_name .. ".vim"
  if vim.fn.filereadable(session_file) == 1 then
    -- The filename itself contains the encoded path
    -- For example: %2FUsers%2Fhs094%2FDev%2Ehs%2FChaosTrack.vim
    -- Decode the filename (without .vim extension) to get the directory
    local filename_without_ext = vim.fn.fnamemodify(session_name, ":r")
    local decoded_path = url_decode(filename_without_ext)
    if decoded_path then
      -- Check if decoded path is a directory
      if vim.fn.isdirectory(decoded_path) == 1 then
        return decoded_path
      end
      -- If not, try to get parent directory (in case filename includes a file)
      local parent_dir = vim.fn.fnamemodify(decoded_path, ":h")
      if vim.fn.isdirectory(parent_dir) == 1 then
        return parent_dir
      end
    end
  end
  -- Last resort: try to use auto-session's internal unescape function if accessible
  local ok, auto_session = pcall(require, "auto-session")
  if ok and auto_session.Lib and auto_session.Lib.unescape_session_name then
    local unescaped = auto_session.Lib.unescape_session_name(session_name)
    if unescaped and vim.fn.isdirectory(unescaped) == 1 then
      return unescaped
    end
  end
  return nil
end

-- Function to change directory after session restore
local function change_to_session_dir(session_name)
  if not session_name then
    return
  end
  local target_dir = get_session_dir(session_name)
  if target_dir and vim.fn.isdirectory(target_dir) == 1 then
    local current_dir = vim.fn.getcwd()
    if current_dir ~= target_dir then
      vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
      vim.notify("Changed directory to: " .. target_dir, vim.log.levels.INFO)
    end
  end
end

return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    -- Ensure sessionoptions includes curdir for proper directory handling
    -- This will be set in the init function via vim.o.sessionoptions
    -- Hook to change directory after restoring a session
    post_restore_cmds = {
      function(session_name)
        change_to_session_dir(session_name)
      end,
    },
    -- The following are already the default values, no need to provide them if these are already the settings you want.
    session_lens = {
      picker = nil, -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also manually choose one. Falls back to vim.ui.select
      mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { "i", "<C-d>" },
        alternate_session = { "i", "<C-s>" },
        copy_session = { "i", "<C-y>" },
      },

      picker_opts = {
        -- For Telescope, you can set theme options here, see:
        -- https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/themes.lua
        --
        -- border = true,
        -- layout_config = {
        --   width = 0.8, -- Can set width and height as percent of window
        --   height = 0.5,
        -- },

        -- For Snacks, you can set layout options here, see:
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-layouts
        --
        -- preset = "dropdown",
        -- preview = false,
        -- layout = {
        --   width = 0.4,
        --   height = 0.4,
        -- },

        -- For Fzf-Lua, picker_opts just turns into winopts, see:
        -- https://github.com/ibhagwan/fzf-lua#customization
        --
        --  height = 0.8,
        --  width = 0.50,
      },

      -- Telescope only: If load_on_setup is false, make sure you use `:AutoSession search` to open the picker as it will initialize everything first
      load_on_setup = true,
    },
  },

  -- Set sessionoptions to include curdir and localoptions for proper session restoration
  init = function()
    -- Recommended sessionoptions for proper filetype and highlighting after session restore
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
}
