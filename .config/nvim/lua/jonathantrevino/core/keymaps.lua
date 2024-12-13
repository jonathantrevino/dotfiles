vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Remove default use of space
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Alternate command mode
map("n", ";", ":", opts)

-- Alternate escape from normal mode
map("i", "jk", "<ESC>", opts)

-- Delete character without copying into register
map("n", "x", '"_x', opts)

-- Find and center
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Split window horizontally
map("n", "ss", "<C-w>s", opts)

-- Move between splits
map("n", "sk", ":wincmd k<CR>", opts)
map("n", "sj", ":wincmd j<CR>", opts)
map("n", "sh", ":wincmd h<CR>", opts)
map("n", "sl", ":wincmd l<CR>", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Keep last yanked when pasting
map("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "<C-k>", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "<C-j>", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Telescope
map("n", ";f", "<cmd>Telescope find_files<cr>", opts)
map("n", ";s", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", opts)
map("n", ";r", "<cmd>Telescope live_grep<cr>", opts)
map("n", ";g", function()
	require("telescope.builtin").treesitter()
end, opts)
map("n", ";b", "<cmd>Telescope buffers<cr>", opts)
map("n", ";h", "<cmd>Telescope help_tags<cr>", opts)

-- Obsidian
map("n", "<leader>oo", ":cd /Users/jonathantrevino/workspace/notes<cr>", opts)
map("n", "<leader>on", ":ObsidianTemplate general<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", opts)
map("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/e | s/-/ /ge<cr>", opts)
map("n", "<leader>os", ':Telescope find_files search_dirs={"~/workspace/notes"} path_display={"tail"}<cr>', opts)
map(
	"n",
	"<leader>oz",
	':Telescope live_grep workspace=CWD search_dirs={"~/workspace/notes"} path_display={"tail"}<cr>',
	opts
)

-- Image paste
map("n", "<leader>v", ":PasteImage<cr>", { desc = "Paste image from sys clipboard", noremap = true, silent = true })

-- File Tree
map("n", "-", ":lua MiniFiles.open()<Return>", opts)

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
