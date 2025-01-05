-- Set leader
vim.keymap.set({ "n", "v"}, "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("n", "-", vim.cmd.Ex) -- :Ex replacement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move lines up & down and indent
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move lines up & down and indent
vim.keymap.set("n", "J", "mzJ`z") -- Bring below line up
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Page up
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Pagdown
vim.keymap.set("n", "n", "nzzzv") -- Next search
vim.keymap.set("n", "N", "Nzzzv") -- Prev search
vim.keymap.set("x", "<leader>p", [["_dP]]) -- deleted lines to void
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]]) -- Yank to main clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- Yank to main clipboard
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
