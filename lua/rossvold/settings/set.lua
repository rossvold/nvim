local set = vim.opt
set.smartcase = true
set.ignorecase = true
set.hlsearch = false
set.incsearch = true
set.inccommand = "split"
set.nu = true
set.relativenumber = true -- Display line numbers relative to the current line
set.splitbelow = true -- Horizontal splits will be below
set.splitright = true -- Vertical splits will be to the right
set.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
set.shada = { "'10", "<0", "s10", "h" } -- Files to remember
set.swapfile = false
set.formatoptions:remove("o") -- Suprising how often this annoys me.
set.wrap = true -- Always keep all text visible on screen.
set.linebreak = true

-- Indent / show blankspace
set.tabstop = 2
set.shiftwidth = 0 -- Defaults to 8, when 0 it's the same as tabstop
set.softtabstop = 8
set.expandtab = false
set.smartindent = true
set.list = true
set.listchars = "tab:| "

-- Folds
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

set.backup = false
set.undofile = true

set.termguicolors = true

set.scrolloff = 8
set.isfname:append("@-@")

set.updatetime = 50

set.colorcolumn = "80,120"

vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]])

-- disable default of ctrl z
vim.keymap.set("n", "<C-z>", "<Nop>")
-- ctrl + z increment number
vim.keymap.set("n", "<C-z>", "<C-a>")
vim.keymap.set({ "n", "v"}, "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("n", "-", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- Lets me paste over v mode text without copying it.
vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
-- Lets me copy with leader+y to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
--paste from system clipboard
vim.keymap.set({"n", "n"}, "<leader>p", [["+p]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Next quicklist item
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
-- Next locallist item
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

-- Open qflist
vim.keymap.set("n", "<C-q>", "<cmd>copen<CR>")
