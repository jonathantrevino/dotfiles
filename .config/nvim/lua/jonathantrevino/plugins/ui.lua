return {
	{
		"nvimdev/dashboard-nvim",
		enabled = false,
	},
	{
		"nvim-lualine/lualine-nvim",
		enabled = false,
	},
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
	},
	{
		"folke/noice.nvim",
		lazy = false,
		event = "VeryLazy",
		opts = {
			presets = {
				bottom_search = true,
				lsp_doc_border = true,
			},
			-- Filter out unnecessary notifications
			routes = {
				-- Remove file written popup notifications
				{
					filter = { event = "msg_show", find = ".*written.*" },
					opts = { skip = true },
				},
				-- Filter out 'loading workspace' and 'workspace complete' notifications
				{
					filter = { event = "msg_show", find = "workspace" },
					opts = { skip = true },
				},
				{
					filter = { event = "msg_show", find = ".*second.*" },
					opts = { skip = true },
				},
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			level = 3,
			timeout = 1000,
			render = "minimal",
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
	},
}
