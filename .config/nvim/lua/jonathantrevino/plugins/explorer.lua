return {{
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
}, 
		{
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
	}
}
