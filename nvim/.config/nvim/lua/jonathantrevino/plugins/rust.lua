return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		require("mason-lspconfig").setup_handlers({
			["rust_analyzer"] = function() end,
		}),
	},
}
