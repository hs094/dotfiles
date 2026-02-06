return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Spectre",
  keys = {
    {
      "<leader>sr",
      function()
        require("spectre").open()
      end,
      desc = "Search & Replace (Spectre)",
    },
    {
      "<leader>sw",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
      mode = { "n", "v" },
      desc = "Replace Word",
    },
    {
      "<leader>sf",
      function()
        require("spectre").open_file_search()
      end,
      desc = "Replace in File",
    },
  },
  config = function()
    require("spectre").setup({
      color_devicons = true,
      open_cmd = "vnew", -- vertical split like VS Code panel
      live_update = false, -- set true if you want instant updates (slower on big repos)
      line_sep_start = "┌────────────────────────────────────────",
      result_padding = "│  ",
      line_sep = "└────────────────────────────────────────",
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffAdd",
      },
      mapping = {
        ["toggle_line"] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "Toggle current item",
        },
        ["enter_file"] = {
          map = "<CR>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "Open file",
        },
        ["send_to_qf"] = {
          map = "<leader>q",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "Send to quickfix",
        },
        ["replace_cmd"] = {
          map = "<leader>rc",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "Replace command",
        },
        ["replace_all"] = {
          map = "<leader>ra",
          cmd = "<cmd>lua require('spectre.actions').replace_all()<CR>",
          desc = "Replace all",
        },
      },
    })
  end,
}

