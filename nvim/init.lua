-- Enable truecolor support
vim.o.termguicolors = true

-- Load Tomorrow Night Blue
vim.cmd.colorscheme "Tomorrow-Night-Blue"

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi NormalFloat guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
]])

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'

vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.opt.timeoutlen = 300

-- Helper to safely require a plugin
local function safe_require(name)
  local ok, mod = pcall(require, name)
  if not ok then
    print("Warning: " .. name .. " not loaded")
    return nil
  end
  return mod
end

-- =========================
-- Oil.nvim
-- =========================
local oil = safe_require("oil")
if oil then
  oil.setup({
    view_options =
    {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    keymaps =
    {
      ["<leader>q"] = { callback = function() vim.cmd("bd") end, desc = "Close oil buffer" },
    }

  })
end

vim.keymap.set('n', '<leader>e', ':Oil<CR>')

-- Load telescope
local ok, telescope = pcall(require, 'telescope.builtin')
if not ok then
  print("Telescope not found")
  return
end

-- Optional: configure defaults (nice UI)
require('telescope').setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    sorting_strategy = "ascending",
  },
}

-- Keymaps
-- Find files in current project
vim.keymap.set('n', '<leader>f', telescope.find_files, { desc = "Find files" })

-- Live grep across project
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = "Grep project" })

-- Live grep in notes folder
vim.keymap.set('n', '<leader>fn', function()
  telescope.live_grep({ cwd = vim.fn.expand('~/workspace/notes') })
end, { desc = "Grep notes" })

-- =========================
-- Modern-style LSP Setup
-- =========================
local augroup = vim.api.nvim_create_augroup("LspAttach", { clear = true })
local map = vim.keymap.set

local function setup_lsp()
  -- Enable LSP servers
  vim.lsp.enable({
    "ts_ls",       -- TypeScript
    "lua_ls",      -- Lua
    "html",        -- HTML
    "cssls",       -- CSS
    "jsonls",      -- JSON
    "tailwindcss", -- TailwindCSS
    "pyright",     -- Python
    "gopls",       -- Go
    "zls",         -- Zig
  })

  -- Attach keymaps and completion when server attaches
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      local bufopts = { noremap = true, silent = true, buffer = ev.buf }

      -- Normal keymaps
      map("n", "gd", vim.lsp.buf.definition, bufopts)
      map("n", "gr", vim.lsp.buf.references, bufopts)
      map("n", "K", vim.lsp.buf.hover, bufopts)
      map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      map("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      map("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, bufopts)

      -- Insert-mode manual completion
      map("i", "<C-k>", vim.lsp.completion.get, bufopts)

      -- Enable completion if supported
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      local methods = vim.lsp.protocol.Methods
      if client:supports_method(methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  })
end

-- Call the setup
setup_lsp()

-- =========================
-- LuaSnip + nvim-cmp Setup (React-friendly)
-- =========================
local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
  print("LuaSnip not found")
  return
end

-- Load Friendly Snippets
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "~/.config/nvim/snippets/friendly-snippets" },
})

-- Explicitly load React/JS/TS snippets
require("luasnip.loaders.from_vscode").lazy_load({ include = { "javascript", "javascriptreact", "typescript", "typescriptreact" } })

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  print("nvim-cmp not found")
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "luasnip", keyword_length = 0 },
    { name = "nvim_lsp" },
    { name = "buffer" },
  }),
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged, cmp.TriggerEvent.InsertEnter },
  },
  experimental = { ghost_text = true },
})

-- Open diagnostic float for current line
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { focusable = false })
end, { noremap = true, silent = true })

-- Close diagnostic float manually
vim.keymap.set("n", "<leader>D", function()
  vim.api.nvim_close_float(0, true)
end, { noremap = true, silent = true })

-- Optional: navigate between diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

-- Optional: populate location list with all diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })


vim.cmd("set completeopt=menu,menuone,noselect")


local vault_path = "/Users/jonathantrevino/workspace"
local notes_path = vault_path .. "/notes"
local quick_path = notes_path .. "/_quick"
local daily_path = vault_path .. "/daily"

-- Ensure all folders exist BEFORE obsidian setup
for _, path in ipairs({ notes_path, quick_path, daily_path }) do
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Now setup obsidian.nvim
require("obsidian").setup({
  workspaces = {
    { name = "personal", path = vault_path },
  },
  notes_subdir = "notes",
  daily_notes = {
    folder = "daily",
    date_format = "%Y-%m-%d",
  },
})

-- Load obsidian.nvim
require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "/Users/jonathantrevino/workspace",
    },
  },
  notes_subdir = "notes",
  daily_notes = {
    folder = "daily",
    date_format = "%Y-%m-%d",
  },
})

-- Set conceal level
vim.opt.conceallevel = 2

-- Enable Treesitter (required)
require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline" },
  highlight = { enable = true },
})

-- Setup render-markdown.nvim
require("render-markdown").setup({
  -- optional configuration
  heading = {
    enabled = true,
  },
  bullet = {
    icons = { "•", "◦", "▸" },
  },
  checkbox = {
    enabled = true
  },
})

-- Follow a link (open the note under cursor)
vim.keymap.set("n", "gf", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow Obsidian link" })

-- Go back to the previous note (like browser back)
vim.keymap.set("n", "gb", "<cmd>ObsidianBacklinks<CR>", { desc = "View backlinks" })

local obsidian_ok, obsidian = pcall(require, "obsidian")
if not obsidian_ok then return end

-- Vault and main notes folder
local vault_path = "/Users/jonathantrevino/workspace"
local notes_path = vault_path .. "/notes"
local quick_path = notes_path .. "/_quick"

-- Ensure folders exist
for _, path in ipairs({ notes_path, quick_path, vault_path .. "/daily" }) do
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Quick note creation
local function new_quick_note()
  vim.ui.input({ prompt = "New note title: " }, function(title)
    if not title or title == "" then return end

    local date = os.date("%Y-%m-%d")
    local filename = date .. "_" .. title:gsub(" ", "-") .. ".md"
    local file_path = quick_path .. "/" .. filename

    local content = {
      "---",
      "tags:",
      "hubs:",
      "url:",
      "date: " .. date,
      "---",
      "",
      "# " .. title,
      ""
    }

    if vim.fn.filereadable(file_path) == 0 then
      vim.fn.writefile(content, file_path)
    end

    vim.cmd("edit " .. file_path)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  end)
end

vim.keymap.set("n", "<leader>nn", new_quick_note, { desc = "Create new note in _quick" })
