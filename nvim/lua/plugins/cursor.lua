return {
	"felixcuello/neovim-cursor",
	config = function()
		require("neovim-cursor").setup({
			-- Multi-terminal keybindings
			keybindings = {
				toggle = "<leader>ai", -- Toggle agent window (show last active)
				new    = "<leader>an", -- Create new agent terminal
				select = "<leader>at", -- Select agent terminal (fuzzy picker)
				rename = "<leader>ar", -- Rename current agent terminal
			},
			-- Terminal naming configuration
			terminal = {
				default_name = "Agent", -- Default name prefix for terminals
				auto_number = true, -- Auto-append numbers (Agent 1, Agent 2, etc.)
			},
			-- Terminal split configuration
			split = {
				position = "right", -- "right", "left", "top", "bottom"
				size = 0.35, -- 35% of editor width
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
		vim.keymap.set("n", "<C-a>", ":CursorAgent<CR>", {
			desc = "Toggle Cursor AI agent terminal (quick)",
		})
		vim.keymap.set("v", "<C-a>", ":CursorAgent<CR>", {
			desc = "Toggle Cursor AI agent and send selection",
		})
	end,
}
