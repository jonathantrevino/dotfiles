return {
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		lazy = false,
		priority = 1200,
		config = function()
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local modified = vim.bo[props.buf].modified
					-- Set color based on modified status
					local filename_color = modified and "#FFFFFF" or "#888888" -- white when modified, gray when not

					local buffer = {
						" ",
						{
							filename .. (modified and "" or ""),
							gui = modified and "bold" or "",
							guifg = filename_color,
						},
						" ",
					}
					return buffer
				end,
			})
		end,
	},
	{
		"mskelton/termicons.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		build = false,
	},
}
