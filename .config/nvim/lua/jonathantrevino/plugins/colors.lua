return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Enable transparency for the background
		vim.g.tokyonight_transparent = true

		-- Set up the theme and configure transparency for the sign column
		require("tokyonight").setup({
			transparent = true,
			on_highlights = function(hl, c)
				-- Make Normal background transparent
				hl.Normal = { bg = "none" }

				-- Make the SignColumn transparent as well
				hl.SignColumn = { bg = "none" }

				-- Optionally, you can also modify other elements like line numbers
				hl.LineNr = { fg = "#888888", bg = "none" }
				hl.CursorLineNr = { fg = "#FFFFFF", bg = "none" }
			end,
		})

		-- Load the colorscheme
		vim.cmd("colorscheme tokyonight")
	end,
}
