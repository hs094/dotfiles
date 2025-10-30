return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          file_ignore_patterns = {
            -- Directories to exclude
            "^%.git/",
            "^node_modules/",
            "^venv/",
            "^%.venv/",
            "^__pycache__/",
            "^%.cache/",
            "^cache/",
            "^%.pytest_cache/",
            "^%.mypy_cache/",
            "^%.ruff_cache/",
            "^%.next/",
            "^%.nuxt/",
            "^%.output/",
            "^dist/",
            "^build/",
            "^target/",
            "^%.idea/",
            "^%.vscode/",
            -- Files to exclude (but keep .env and .gitignore)
            "^%.DS_Store$",
            "^thumbs%.db$",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            follow = true,
            -- Include hidden files but exclude the patterns above
            no_ignore = false,
            -- Use file_ignore_patterns from defaults, which works with fd/find/rg
            -- Don't respect .gitignore so .env, .python_version etc are visible
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--no-ignore-vcs", -- Include files ignored by .gitignore
              "--glob", "!.git",
              "--glob", "!node_modules",
              "--glob", "!venv",
              "--glob", "!.venv",
              "--glob", "!__pycache__",
              "--glob", "!.cache",
              "--glob", "!dist",
              "--glob", "!build",
              "--glob", "!.next",
              "--glob", "!.nuxt",
              "--glob", "!.idea",
              "--glob", "!.vscode",
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
          },
        },
      })

      -- Telescope keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<C-p>', builtin.find_files, {
        desc = 'Find files with Telescope'
      })
      vim.keymap.set('n', '<leader>rg', builtin.live_grep, {
        desc = 'Live grep with Telescope'
      })
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").load_extension("ui-select")
    end
  }
}
