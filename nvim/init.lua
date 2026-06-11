vim.opt.termguicolors=true

vim.opt.relativenumber=true
vim.opt.signcolumn="yes"
vim.opt.number=true
vim.opt.wrap=false

vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.smartindent=true

vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.hlsearch=false

vim.opt.clipboard="unnamedplus"

vim.cmd("colorscheme Tomorrow-Night-Blue")

vim.g.mapleader=" "
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>")

-- Keep cursor centered when jumping half pages 
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when cycling through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move highlighted text up and down using Shift + J or Shift + K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Stay in visual mode while indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>e", ":Ex<CR>") -- full width file explorer
vim.keymap.set("n", "<leader>E", ":Lex 30<CR>") -- 30% file explorer

-- Jump between windows seamlessly using Ctrl + direction
vim.keymap.set("n", "<C-h>", "<C-w>h") -- move left
vim.keymap.set("n", "<C-l>", "<C-w>l") -- move right

-- Custom Netrw Keymaps (Oil-style file creation)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        -- Map 'o' to create a new file (replaces native '%')
        vim.keymap.set("n", "o", "%", { remap = true, buffer = true })
        
        -- Map 'O' (Shift + o) to create a new folder/directory (replaces native 'd')
        vim.keymap.set("n", "O", "d", { remap = true, buffer = true })
    end,
})

-- add lsp
vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

-- 1. Setup your language servers
vim.lsp.enable({"gopls", "lua_ls, tailwindcss", "terraform_ls", "html", "ts_ls", "cssls", "eslint"})

-- 2. Global Diagnostic Shortcuts (Errors/Warnings)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev) -- Jump to previous error
vim.keymap.set('n', ']d', vim.diagnostic.goto_next) -- Jump to next error
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float) -- Show error details in a popup

-- 3. LSP-Specific Shortcuts (Only activate when a valid code file opens)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        
        -- gd -> Go to Definition
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        
        -- K -> Hover (Shows documentation popup for the function/type under cursor)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        
        -- <leader>rn -> Rename all instances of a variable across the project
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        
        -- <leader>ca -> Code Actions (Auto-imports, quick fixes)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        
        -- gr -> Go to References (Find where this function is used elsewhere)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end,
})
