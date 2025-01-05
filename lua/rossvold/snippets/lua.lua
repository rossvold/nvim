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

	s("vimcmd", {
		t('vim.cmd([['),
		i(1),
		t(']])'),
	}),

	s("autocmd", {
		t('local autocmd = vim.api.nvim_create_autocmd'),
	}),

	s("create_autocmd", fmt([[
local autocmd = vim.api.nvim_create_autocmd
local {node1} = vim.api.nvim_create_augroup("{node2}", {{}})
autocmd("{node3}", {{
	group = {node1},
	callback = function()
		{node4}
	end,
}})
]], {
			node1 = i(1, "group"),
			node2 = i(2, "AutocmdGroupName"),
			node3 = i(3, "Bufferevent"),
			node4 = i(4, ""),
		},
		{
			repeat_duplicates = true
		})),
})
