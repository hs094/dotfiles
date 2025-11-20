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
			vim.keymap.seti("n", "<leader>cp", ":Copilot status<CR>", {
				desc = "Show Copilot status",
			})
			vim.keymap.seti("n", "<leader>cps", ":Copilot panel<CR>", {
				desc = "Open Copilot panel",
			})
		end,
	},
	-- neovim-cursor: Full-featured Cursor Agent integration with multi-terminal support
	-- Use this for complex workflows, multiple agent sessions, and terminal organization
	{
		"felixcuello/neovim-cursor",
		config = function()
			require("neovim-cursor").setup({
				-- Multi-terminal keybindings
				keybindings = {
					toggle = "<leader>ai",      -- Toggle agent window (show last active)
					new = "<leader>an",          -- Create new agent terminal
					select = "<leader>at",       -- Select agent terminal (fuzzy picker)
					rename = "<leader>ar",       -- Rename current agent terminal
				},
				-- Terminal naming configuration
				terminal = {
					default_name = "Agent",      -- Default name prefix for terminals
					auto_number = true,          -- Auto-append numbers (Agent 1, Agent 2, etc.)
				},
				-- Terminal split configuration
				split = {
					position = "right",          -- "right", "left", "top", "bottom"
					size = 0.35,                 -- 35% of editor width
				},
				-- CLI command to run
				command = "cursor agent",
				-- Terminal callbacks
				term_opts = {
					on_open = function()
						vim.cmd("startinsert")
						vim.notify("Cursor agent started - Use <leader>at to switch agents", vim.log.levels.INFO)
					end,
					on_close = function(exit_code)
						vim.notify("Cursor agent closed", vim.log.levels.INFO)
					end,
				},
			})
			-- Additional keymaps for quick access
			vim.keymap.seti("n", "<C-a>", ":CursorAgent<CR>", {
				desc = "Toggle Cursor AI agent terminal (quick)",
			})
			vim.keymap.seti("v", "<C-a>", ":CursorAgent<CR>", {
				desc = "Toggle Cursor AI agent and send selection",
			})
		end,
	},
}
