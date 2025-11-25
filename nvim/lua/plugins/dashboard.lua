return {
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
}
