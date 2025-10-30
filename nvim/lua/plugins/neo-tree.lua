return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      -- Ensure nvim-web-devicons is properly loaded first
      local devicons = require("nvim-web-devicons")
      devicons.setup({
        override = {},
        default = true,
      })
      
      -- Recommended: Set a highlight for the neo-tree indent markers
      vim.cmd([[highlight NeoTreeIndentMarker guifg=#3b4261]])
      
      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
        
        filesystem = {
          -- Always show hidden files and dotfiles
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          
          -- Hide specific files/folders
          filtered_items = {
            visible = false, -- Hidden items are not visible by default
            hide_dotfiles = false, -- Show dotfiles
            hide_gitignored = false, -- Show gitignored files
            hide_by_name = {
              ".git", -- Hide .git folder specifically
              -- "node_modules", -- Uncomment to hide node_modules
            },
            hide_by_pattern = {
              -- "*.meta", -- Example: hide Unity meta files
            },
            always_show = { -- Explicitly always show these
              ".gitignore",
              ".env",
            },
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
          },
          bind_to_cwd = false,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          use_libuv_file_watcher = true,
        },
        buffers = {
          bind_to_cwd = false,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          group_empty_dirs = true,
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            }
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            }
          }
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.relativenumber = false
              vim.opt_local.number = false
            end,
          },
        },
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false,
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel",
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              config = {
                show_path = "none"
              }
            },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          },
        },
        nesting_rules = {},
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            -- Let nvim-web-devicons handle folder icons
            -- Only set fallback if needed
            default = " ",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = "",
              modified  = "",
              deleted   = "✖",
              renamed   = "󰁕",
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            }
          },
          file_size = {
            enabled = true,
            required_width = 64,
          },
          type = {
            enabled = true,
            required_width = 122,
          },
          last_modified = {
            enabled = true,
            required_width = 88,
          },
          created = {
            enabled = true,
            required_width = 110,
          },
          symlink_target = {
            enabled = false,
          },
        },
        commands = {},
      })
      -- Optional: Set up keymaps for neo-tree
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true, desc = 'Toggle Neo-tree' })
      vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', { noremap = true, silent = true, desc = 'Focus Neo-tree' })
      -- IMPORTANT: For icons to display properly, you need:
      -- 1. A Nerd Font installed (e.g., JetBrainsMono Nerd Font, FiraCode Nerd Font)
      -- 2. Your terminal configured to use the Nerd Font
      -- 3. If using Neovim in terminal, set: vim.opt.termguicolors = true (in init.lua)
      --
      -- Download Nerd Fonts from: https://www.nerdfonts.com/
      -- Recommended fonts: JetBrainsMono, FiraCode, Hack, Meslo
    end,
  }
}
