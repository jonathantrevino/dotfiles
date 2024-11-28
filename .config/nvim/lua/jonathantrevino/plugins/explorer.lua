return {
	"echasnovski/mini.nvim",
	lazy = false,
	config = function()
		require("mini.files").setup({
			mappings = {
				go_in_plus = "<CR>",
				go_out = "H",
				go_out_plus = "h",
			},
			options = {
				permanent_delete = true,
				use_as_default_explorer = true,
			},
		})
	end,
}
