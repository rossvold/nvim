require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	sync_install = false,

	-- Install parsers synchronously (only applied to `ensure_installed`)
	auto_install = false,

	highlight = { enable = true },

	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
	ensure_installed = {
		"rust",
		"c",
		"zig",
		"javascript",
		"typescript",
		"scss",
		"html",
		"css",
		"lua",
		"svelte",
		"vim",
		"vimdoc",
		"query",
		"templ",
		"python",
		"sql",
	},
	-- THE GOAT OF VIM STRUCTURAL EDITING. Select, move, quries.
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["ac"] = "@comment.outer",
				["ic"] = "@comment.outer",
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				["ao"] = "@class.outer",
				["io"] = "@class.inner",
				["iA"] = "@attribute.inner",
				["aA"] = "@attribute.outer",
				["ir"] = "@return.inner",
				["ar"] = "@return.outer",
			},
			include_surrounding_whitespace = false, -- Many select operations becomes 10x more useful with this set to false
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["mf"] = "@function.outer",
				["ml"] = "@loop.outer",
				["mc"] = "@comment.outer",
				["mi"] = "@conditional.outer",
				["mn"] = "@assignment.lhs", -- Variable selector name
				["mv"] = "@assignment.rhs", -- Variable select value
				["mo"] = "@class.outer",
				["mp"] = "@parameter_actual.outer",
				["mt"] = "@element_text", -- HTML ELEMENT TEXT
				["mA"] = "@attribute.outer", -- HTML attribute
				["mr"] = "@return.outer",
				["me"] = "@element.start",
				["ms"] = "@string", -- Jump to next string
				["mI"] = "@integer", -- Jump to next string
			},
			goto_previous_start = {
				["Mf"] = "@function.outer",
				["Ml"] = "@loop.outer",
				["Mc"] = "@comment.outer",
				["Mi"] = "@conditional.outer",
				["Mn"] = "@assignment.lhs", -- Variable selector name
				["Mv"] = "@assignment.rhs", -- Variable select value
				["Mo"] = "@class.outer",
				["Mp"] = "@parameter_actual.outer",
				["mT"] = "@element_text", -- HTLM ELEMENT TEXT
				["MA"] = "@attribute.outer", -- HTML attribute
				["Mr"] = "@return.outer",
				["Me"] = "@element.start",
				["Ms"] = "@string",
				["MI"] = "@integer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>l"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>h"] = "@parameter.inner",
			},
		},
		-- End of textobjects
	},
})
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
-- ensure , goes forward and ; goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_previous)

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 20, -- Maximum number of lines to show for a single context
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = nil,
	zindex = 20, -- The Z-index of the context window
	on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})

local ts = vim.treesitter

local function query_to_qflist(capture_name, query_str)
	local bufnr = vim.api.nvim_get_current_buf()
	local parser = ts.get_parser(bufnr, vim.bo.filetype)
	local tree = parser:parse()[1]
	local root = tree:root()

	local ok, ts_query = pcall(ts.query.parse, vim.bo.filetype, query_str)
	if not ok then
		vim.notify("Query failed: " .. ts_query, vim.log.levels.ERROR)
		return
	end

	local qflist = {}
	for id, node in ts_query:iter_captures(root, bufnr, 0, -1) do
		local name = ts_query.captures[id]
		if name == capture_name then
			local start_row, start_col = node:range()
			local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
			table.insert(qflist, {
				bufnr = bufnr,
				lnum = start_row + 1,
				col = start_col + 1,
				text = line,
			})
		end
	end

	if #qflist == 0 then
		vim.notify("No matches found for " .. capture_name, vim.log.levels.INFO)
	else
		vim.fn.setqflist(qflist, "r")
		vim.cmd("copen")
	end
end

-- Map of key suffix to {capture_name, query}
local query_map = {
	f = { "function.outer", [[((function_declaration) @function.outer)]] },
	F = { "function.outer", [[
		(function_declaration) @function.outer
		(arrow_function) @function.outer
]] },
	r = { "return.outer", [[(return_statement) @return.outer]] },
	l = { "loop.outer", [[(for_statement) @loop.outer (while_statement) @loop.outer]] },
	c = { "comment.outer", [[(comment) @comment.outer]] },
	i = { "conditional.outer", [[(if_statement) @conditional.outer (switch_statement) @conditional.outer]] },
	o = { "class.outer", [[(class_declaration) @class.outer]] },
	a = { "attribute.outer", [[(attribute) @attribute.outer]] },
}

for key, data in pairs(query_map) do
	local capture, query = unpack(data)
	local command_name = "TSQF" .. key

	vim.api.nvim_create_user_command(command_name, function()
		query_to_qflist(capture, query)
	end, {})

	vim.keymap.set("n", "<Leader>m" .. key, function()
		vim.cmd(command_name)
	end, { desc = "TS query " .. capture .. " to quickfix" })
end
