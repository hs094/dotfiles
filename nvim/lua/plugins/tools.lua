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
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				-- config
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>db",
				-- 	"<cmd>Dashboard<CR>",
				-- 	{ noremap = true, silent = true, desc = "Open Dashboard" }
				-- ),
			})
		end,
		requires = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
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
}
