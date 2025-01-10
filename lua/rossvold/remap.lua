vim.keymap.set({ "n", "v"}, "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<C-z>", "<Nop>") -- disable default of ctrl z
vim.keymap.set("n", "<C-z>", "<C-a>") -- ctrl + z increment number

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z") -- Bring below up & indent
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- jump up
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- jump down
vim.keymap.set("n", "n", "nzzzv") -- Center screen after jumping to next element
vim.keymap.set("n", "N", "Nzzzv") -- Center screen after jumping to previous element

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
vim.keymap.set({"n", "v", "i"}, '<A-s>', ':w<CR>', { noremap = true, silent = true })

--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Next quicklist item
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
-- Next locallist item
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

-- Toggle qflist
vim.keymap.set("n", "<C-q>", function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
            break
        end
    end
    if qf_exists then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end)
