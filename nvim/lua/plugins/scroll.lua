return {
	"karb94/neoscroll.nvim",
	opts = {
		mappings = { -- Keys mapped to scrolling animations
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at EOF when scrolling downwards
		respect_scrolloff = false, -- Ignore scrolloff margin
		cursor_scrolls_alone = true, -- Cursor keeps scrolling even if window can't
		duration_multiplier = 1.0, -- Global duration multiplier
		easing = "linear", -- Easing function
		pre_hook = nil, -- Function before animation
		post_hook = nil, -- Function after animation
		performance_mode = false, -- Disable performance mode
		ignored_events = { -- Events ignored while scrolling
			"WinScrolled",
			"CursorMoved",
		},
	},
}
