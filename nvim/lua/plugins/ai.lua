return {
	{
		"github/copilot.vim",
		config = function()
			-- Enable tab completion for Copilot
			vim.g.copilot_no_tab_map = true
			-- Set up keybindings for Copilot
			vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-J>", "copilot#Next()", { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Previous()", { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-O>", "copilot#Dismiss()", { silent = true, expr = true })
			-- Optional: Set up visual mode keybindings
			vim.api.nvim_set_keymap("v", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

			-- Copilot keymaps
			vim.keymap.set("n", "<leader>cp", ":Copilot status<CR>", {
				desc = "Show Copilot status",
			})
			vim.keymap.set("n", "<leader>cps", ":Copilot panel<CR>", {
				desc = "Open Copilot panel",
			})
		end,
	},
	-- neovim-cursor: Full-featured Cursor Agent integration with multi-terminal support
	-- Use this for complex workflows, multiple agent sessions, and terminal organization
}	
