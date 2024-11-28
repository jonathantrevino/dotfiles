return {
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup({
				mappings = {
					-- Move visual selection in Visual mode
					left = "<Space>-h", -- Space + h for left
					right = "<Space>l", -- Space + l for right
					down = "<Space>j", -- Space + j for down
					up = "<Space>k", -- Space + k for up

					-- Move current line in Normal mode
					line_left = "<Space>h",
					line_right = "<Space>l",
					line_down = "<Space>j",
					line_up = "<Space>k",
				},
				options = {
					-- Automatically reindent selection during linewise vertical move
					reindent_linewise = true,
				},
			})
		end,
	},
}
