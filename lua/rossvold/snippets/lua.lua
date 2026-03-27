local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("lua", {
	s("test", {
		t('print("hello '),
		i(1),
		t('world")'),
	}),

	s("cmd", {
		t('vim.cmd([['),
		i(1),
		t(']])'),
	}),

	s("autocmd", fmt([[
local {node1} = vim.api.nvim_create_augroup("{node2}", {{}})
local autocmd = vim.api.nvim_create_autocmd]], {
		node1 = i(1, "group"),
		node2 = i(2, "GroupName"),
	}, { repeat_duplicates = true })),

	s("create_autocmd", fmt([[
autocmd("{node1}", {{
	group = {node2},
	pattern = "{node3}",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local opts = {{ buffer = bufnr, remap = false }}
		{node4}
	end,
}})
]], {
			node1 = i(1, "FileType"),
			node2 = i(2, "group"),
			node3 = i(3, "pattern"),
			node4 = i(4, ""),
		},
		{
			repeat_duplicates = true
		})),
})
