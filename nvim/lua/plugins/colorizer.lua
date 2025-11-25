return {
	"norcalli/nvim-colorizer.lua",
	lazy = "VeryLazy",
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
}
