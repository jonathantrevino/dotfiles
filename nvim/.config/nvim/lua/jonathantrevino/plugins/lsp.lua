return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- -- Override the LSP progress notification handler to suppress messages
		-- vim.lsp.handlers["$/progress"] = function() end
		-- LSP integration
		-- Make sure to also have the snippet with the common helper functions in your config!
		--
		-- Utility functions shared between progress reports for LSP and DAP
		--

		vim.notify = require("notify")

		-- Utility functions shared between progress reports for LSP and DAP

		local client_notifs = {}

		local function get_notif_data(client_id, token)
			if not client_notifs[client_id] then
				client_notifs[client_id] = {}
			end

			if not client_notifs[client_id][token] then
				client_notifs[client_id][token] = {}
			end

			return client_notifs[client_id][token]
		end

		local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

		local function update_spinner(client_id, token)
			local notif_data = get_notif_data(client_id, token)

			if notif_data.spinner then
				local new_spinner = (notif_data.spinner + 1) % #spinner_frames
				notif_data.spinner = new_spinner

				notif_data.notification = vim.notify(nil, nil, {
					hide_from_history = true,
					icon = spinner_frames[new_spinner],
					replace = notif_data.notification,
				})

				vim.defer_fn(function()
					update_spinner(client_id, token)
				end, 100)
			end
		end

		local function format_title(title, client_name)
			return client_name .. (#title > 0 and ": " .. title or "")
		end

		local function format_message(message, percentage)
			return (percentage and percentage .. "%\t" or "") .. (message or "")
		end

		-- LSP integration
		-- Make sure to also have the snippet with the common helper functions in your config!

		vim.lsp.handlers["$/progress"] = function(_, result, ctx)
			local client_id = ctx.client_id

			local val = result.value

			if not val.kind then
				return
			end

			local notif_data = get_notif_data(client_id, result.token)

			if val.kind == "begin" then
				local message = format_message(val.message, val.percentage)

				notif_data.notification = vim.notify(message, "info", {
					title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
					icon = spinner_frames[1],
					timeout = false,
					hide_from_history = false,
				})

				notif_data.spinner = 1
				update_spinner(client_id, result.token)
			elseif val.kind == "report" and notif_data then
				notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
					replace = notif_data.notification,
					hide_from_history = false,
				})
			elseif val.kind == "end" and notif_data then
				notif_data.notification =
					vim.notify(val.message and format_message(val.message) or "Complete", "info", {
						icon = "",
						replace = notif_data.notification,
						timeout = 3000,
					})

				notif_data.spinner = nil
			end
		end

		-- Autocommand for when LSP attaches to a buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Set up mappings
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Define your mappings
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Highlight references
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- Toggle inlay hints if supported
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- LSP capabilities setup
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Define your LSP servers
		local servers = {
			ts_ls = {},
			ruff = {},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},
			dockerls = {},
			sqlls = {},
			terraformls = {},
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						diagnostics = { disable = { "missing-fields" } },
						format = { enable = false },
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		require("mason").setup()
		local ensure_installed = vim.tbl_keys(servers or {})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				-- Fallback handler for other servers
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
