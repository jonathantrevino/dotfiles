return {
	-- Obsidian
	{
		"epwalsh/obsidian.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			disable_frontmatter = true,
			workspaces = {
				{
					name = "notes",
					path = "/Users/jonathantrevino/workspace/notes",
				},
			},
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
		},
		notes_subdir = "",
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
	},

	-- View Images
	{
		-- luarocks.nvim is a Neovim plugin designed to streamline the installation
		-- of luarocks packages directly within Neovim. It simplifies the process
		-- of managing Lua dependencies, ensuring a hassle-free experience for
		-- Neovim users.
		-- https://github.com/vhyrro/luarocks.nvim
		"vhyrro/luarocks.nvim",
		-- this plugin needs to run before anything else
		priority = 1001,
		lazy = false,
		opts = {
			rocks = { "magick" },
		},
	},
	{
		"3rd/image.nvim",
		lazy = false,
		dependencies = { "luarocks.nvim" },
		config = function()
			require("image").setup({
				backend = "kitty",
				kitty_method = "normal",
				integrations = {
					-- Notice these are the settings for markdown files
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						-- Set this to false if you don't want to render images coming from
						-- a URL
						download_remote_images = true,
						-- Change this if you would only like to render the image where the
						-- cursor is at
						-- I set this to true, because if the file has way too many images
						-- it will be laggy and will take time for the initial load
						only_render_image_at_cursor = true,
						-- markdown extensions (ie. quarto) can go here
						filetypes = { "markdown", "vimwiki" },
					},
					neorg = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						filetypes = { "norg" },
					},
					-- This is disabled by default
					-- Detect and render images referenced in HTML files
					-- Make sure you have an html treesitter parser installed
					-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
					html = {
						enabled = true,
					},
					-- This is disabled by default
					-- Detect and render images referenced in CSS files
					-- Make sure you have a css treesitter parser installed
					-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
					css = {
						enabled = true,
					},
				},
				max_width = nil,
				max_height = nil,
				max_width_window_percentage = nil,

				-- This is what I changed to make my images look smaller, like a
				-- thumbnail, the default value is 50
				-- max_height_window_percentage = 20,
				max_height_window_percentage = 60,

				-- toggles images when windows are overlapped
				window_overlap_clear_enabled = false,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

				-- auto show/hide images when the editor gains/looses focus
				editor_only_render_when_focused = true,

				-- auto show/hide images in the correct tmux window
				-- In the tmux.conf add `set -g visual-activity off`
				tmux_show_only_in_active_window = true,

				-- render image files as images when opened
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
			})
		end,
	},
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		lazy = false,
		opts = {
			-- add options here
			-- or leave it empty to use the default settings
			default = {

				-- file and directory options
				-- expands dir_path to an absolute path
				-- When you paste a new image, and you hover over its path, instead of:
				-- test-images-img/2024-06-03-at-10-58-55.webp
				-- You would see the entire path:
				-- /Users/linkarzu/github/obsidian_main/999-test/test-images-img/2024-06-03-at-10-58-55.webp
				--
				-- IN MY CASE I DON'T WANT TO USE ABSOLUTE PATHS
				-- if I switch to a nother computer and I have a different username,
				-- therefore a different home directory, that's a problem because the
				-- absolute paths will be pointing to a different directory
				use_absolute_path = false, ---@type boolean

				-- make dir_path relative to current file rather than the cwd
				-- To see your current working directory run `:pwd`
				-- So if this is set to false, the image will be created in that cwd
				-- In my case, I want images to be where the file is, so I set it to true
				relative_to_current_file = true, ---@type boolean

				-- I want to save the images in a directory named after the current file,
				-- but I want the name of the dir to end with `-img`
				dir_path = function()
					return vim.fn.expand("%:t:r") .. "-img"
				end,

				-- If you want to get prompted for the filename when pasting an image
				-- This is the actual name that the physical file will have
				-- If you set it to true, enter the name without spaces or extension `test-image-1`
				-- Remember we specified the extension above
				--
				-- I don't want to give my images a name, but instead autofill it using
				-- the date and time as shown on `file_name` below
				prompt_for_file_name = false, ---@type boolean
				file_name = "%Y-%m-%d-at-%H-%M-%S", ---@type string

				-- -- Set the extension that the image file will have
				-- -- I'm also specifying the image options with the `process_cmd`
				-- -- Notice that I HAVE to convert the images to the desired format
				-- -- If you don't specify the output format, you won't see the size decrease

				-- extension = "avif", ---@type string
				-- process_cmd = "convert - -quality 75 avif:-", ---@type string

				extension = "webp", ---@type string
				process_cmd = "convert - -quality 75 -resize 75% webp:-", ---@type string
			},

			-- filetype specific options
			filetypes = {
				markdown = {
					-- encode spaces and special characters in file path
					url_encode_path = true, ---@type boolean

					template = "![$FILE_NAME]($FILE_PATH)", ---@type string
				},
			},
		},
	},
}
