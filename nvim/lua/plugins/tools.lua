return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = false, -- Disable week header to save space
					},
					packages = { enable = false }, -- Disable packages count to save space
					project = {
						enable = true,
						limit = 4, -- Reduced from default 8
						icon = "󰉋 ",
						label = "",
						action = "Telescope find_files cwd=",
					},
					mru = {
						enable = true,
						limit = 5, -- Reduced from default 10
						icon = "󰈙 ",
						label = "",
						cwd_only = false,
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return { "󰥔  Startup time: " .. ms .. "ms" }
					end,
				},
			})
		end,
		requires = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
		opts = {},
	},
	{
		"j-hui/fidget.nvim",
	},
	-- {
	-- 	"vimpostor/vim-tpipeline",
	-- 	config = function()
	-- 		require("tpipeline").setup()
	-- 	end,
	-- },
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			-- Ensure true color support is enabled
			vim.opt.termguicolors = true

			-- Attach to all filetypes with common options
			require("colorizer").setup({
				"*", -- All filetypes
				css = { rgb_fn = true }, -- Enable rgb() functions in CSS
				html = { names = false }, -- Disable color names in HTML
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		keys = {
			{ "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate left (tmux/vim)" },
			{ "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate down (tmux/vim)" },
			{ "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate up (tmux/vim)" },
			{ "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate right (tmux/vim)" },
			{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate to previous (tmux/vim)" },
		},
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
	},
	-- {
	-- 	"kevinhwang91/nvim-ufo",
	-- 	dependencies = { "kevinhwang91/promise-async" },
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 	-- Configure fold settings
	-- 	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	-- 	vim.o.foldlevelstart = 99
	-- 	vim.o.foldenable = false -- Disable automatic folding
	--
	-- 		-- Fix line numbers with folding
	-- 		-- Set foldcolumn to 0 to prevent interference with line numbers
	-- 		-- nvim-ufo will handle fold indicators through virtual text
	-- 		vim.o.foldcolumn = "0"
	-- 		-- Ensure number column has adequate width
	-- 		vim.o.numberwidth = 4
	--
	-- 		-- Setup ufo with LSP foldingRange capability
	-- 		-- Note: This requires LSP servers to have foldingRange capability
	-- 		-- The capability should be added in lsp-config.lua
	-- 		require("ufo").setup({
	-- 			open_fold_hl_timeout = 400,
	-- 			close_fold_kinds_for_ft = {
	-- 				default = { "imports", "comment" },
	-- 			},
	-- 			preview = {
	-- 				win_config = {
	-- 					border = "rounded",
	-- 					winblend = 12,
	-- 					winhighlight = "Normal:Normal",
	-- 					maxheight = 20,
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		-- Using ufo provider need remap `zR` and `zM`
	-- 		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
	-- 		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
	-- 		vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
	-- 		vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with level" })
	--
	-- 		-- Enhanced K keymap: peek folded lines or show LSP hover
	-- 		vim.keymap.set("n", "K", function()
	-- 			local winid = require("ufo").peekFoldedLinesUnderCursor()
	-- 			if not winid then
	-- 				vim.lsp.buf.hover()
	-- 			end
	-- 		end, { desc = "Peek folded lines or LSP hover" })
	-- 	end,
	-- },
}
