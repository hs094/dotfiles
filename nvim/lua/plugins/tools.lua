return {
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
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
