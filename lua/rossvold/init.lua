require("rossvold.settings")
require("rossvold.remap")
require("rossvold.lazy_init") -- Set & remap has to always be in front of lazy_init
require("rossvold.terminal.terminal")

local autocmd = vim.api.nvim_create_autocmd

local ibraGroup = vim.api.nvim_create_augroup("ibraGroup", {})
local yank_group = vim.api.nvim_create_augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = ibraGroup,
	pattern = "*",
	callback = function()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, cursor_pos)
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
