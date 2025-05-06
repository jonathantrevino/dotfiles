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
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
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
	-- Add these plugin configurations to your LazyVim plugin configuration file
	{
		"echasnovski/mini.hipatterns",
		version = false, -- Automatically use the latest version
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},
	{
		"echasnovski/mini.icons",
		version = false, -- Automatically use the latest version
		config = function()
			require("mini.icons").setup({
				-- You can add custom options here if needed.
			})
		end,
	},
}
