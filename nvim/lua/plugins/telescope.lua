return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					path_display = { "truncate" },
					winblend = 0,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" },
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
							"--glob",
							"!.git",
							"--glob",
							"!node_modules",
							"--glob",
							"!venv",
							"--glob",
							"!.venv",
							"--glob",
							"!__pycache__",
							"--glob",
							"!.cache",
							"--glob",
							"!dist",
							"--glob",
							"!build",
							"--glob",
							"!.next",
							"--glob",
							"!.nuxt",
							"--glob",
							"!.idea",
							"--glob",
							"!.vscode",
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			-- Telescope keymaps
			local builtin = require("telescope.builtin")
			vim.keymap.seti("n", "<leader>ff", builtin.find_files, {
				desc = "Find files with Telescope",
			})
			vim.keymap.seti("n", "<leader>rg", builtin.live_grep, {
				desc = "Live grep with Telescope",
			})
			vim.keymap.seti("n", "<leader>db", function()
				require("telescope.builtin").diagnostics({ bufnr = 0 })
			end, {
        desc = "Buffer Diagnostics",
      })
			vim.keymap.seti("n", "<leader>dw", function()
				require("telescope.builtin").diagnostics()
			end, {
        desc = "Workspace Diagnostics",
      })
			vim.keymap.seti("n", "<leader>fs", function()
				require("telescope.builtin").lsp_document_symbols()
			end, {
				desc = "Find Symbols",
			})
      vim.keymap.seti("n", "<leader>fb", function()
        require("telescope.builtin").buffers()
      end, {
        desc = "Find Buffers",
      })
      vim.keymap.seti("n", "<leader>fw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, {
        desc = "Find Words",
      })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
}
