return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Telescope",
		keys = {
			{
				"<leader>ff",
				function() require("telescope.builtin").find_files() end,
				desc = "Find files with Telescope",
			},
			{
				"<leader>fs",
				function() require("telescope.builtin").lsp_document_symbols() end,
				desc = "Find Symbols",
			},
			{
				"<leader>fw",
				function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
				desc = "Find Words",
			},
		},
		opts = {
			defaults = {
				path_display = { "truncate" },
				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
					"%.venv/",
					"__pycache__/",
					"%.cache/",
					"dist/",
					"build/",
					"target/",
					"%.next/",
					"%.idea/",
					"%.vscode/",
					"%.DS_Store$",
				},
			},
			pickers = {
				find_files = { hidden = true },
				live_grep = { additional_args = { "--hidden" } },
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
}
