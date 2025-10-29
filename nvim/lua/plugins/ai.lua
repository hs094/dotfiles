return {
	{
		"github/copilot.vim",
		config = function()
			-- Enable tab completion for Copilot
			vim.g.copilot_no_tab_map = false
			-- Set up keybindings for Copilot
			vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Next()', { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Previous()', { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-O>", 'copilot#Dismiss()', { silent = true, expr = true })
			-- Optional: Set up visual mode keybindings
			vim.api.nvim_set_keymap("v", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		end,
	},
	{
		"felixcuello/neovim-cursor",
		config = function()
			require("neovim-cursor").setup({
				keybinding = "<C-a>",
				split = {
					position = "right",
					size = 0.30,
				},
				command = "cursor agent",
				term_opts = {
					on_open = function()
						vim.cmd("startinsert")
						-- Remove noremap to allow C-a to trigger the plugin's keybinding
						vim.api.nvim_buf_set_keymap(0, "t", "<C-a>", "<C-\\><C-n><C-a>", { silent = true })
						vim.notify("Cursor agent started - Press <C-a> again to toggle", vim.log.levels.INFO)
					end,
					on_close = function(exit_code)
						vim.notify("Cursor agent closed", vim.log.levels.INFO)
					end,
				},
			})
		end,
	},
}
