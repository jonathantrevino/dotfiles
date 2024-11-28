-- Add this to your LazyVim plugin configuration file
return {
	{
		"echasnovski/mini.surround",
		version = false, -- Automatically use the latest version
		config = function()
			require("mini.surround").setup({
				-- Custom configuration options for `mini.surround` can go here.
				-- Example options:
				mappings = {
					-- Change surrounding characters
					add = "sa", -- Add surrounding (e.g., "sa(" to add parentheses)
					delete = "sd", -- Delete surrounding (e.g., "sd" to remove surrounding)
					replace = "sr", -- Replace surrounding (e.g., "sr(" to replace with parentheses)
					-- You can customize these as needed.
				},
			})
		end,
	},
}
