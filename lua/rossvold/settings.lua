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
set.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.foldcolumn = "0" -- '0' is not bad
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
