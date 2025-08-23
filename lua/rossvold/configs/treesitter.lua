-- luacheck: globals vim
---@diagnostic disable: undefined-global
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

local function query_to_qflist(capture_name, fallback_query)
	local bufnr = vim.api.nvim_get_current_buf()
	local lang = require("nvim-treesitter.parsers").ft_to_lang(vim.bo.filetype)
	local parser = ts.get_parser(bufnr, lang)
	local tree = parser:parse()[1]
	local root = tree:root()

	-- Prefer the language's installed/extended textobjects query from runtime (honors after/queries)
	local ts_query
	local get = vim.treesitter.query.get or vim.treesitter.query.get_query
	local ok_get, q = pcall(get, lang, "textobjects")
	if ok_get and q then
		-- Ensure the capture exists in this language
		local has_capture = false
		for _, name in pairs(q.captures or {}) do
			if name == capture_name then
				has_capture = true
				break
			end
		end
		if has_capture then
			ts_query = q
		else
			if fallback_query and #fallback_query > 0 then
				local ok_parse, parsed = pcall(ts.query.parse, lang, fallback_query)
				if not ok_parse then
					vim.notify("Query failed: " .. parsed, vim.log.levels.ERROR)
					return
				end
				ts_query = parsed
			else
				vim.notify(("Missing capture '%s' for language '%s'. Add it under after/queries/%s/textobjects.scm.")
					:format(capture_name, lang, lang), vim.log.levels.WARN)
				return
			end
		end
	else
		-- No language textobjects query available; try fallback if provided
		if fallback_query and #fallback_query > 0 then
			local ok_parse, parsed = pcall(ts.query.parse, lang, fallback_query)
			if not ok_parse then
				vim.notify("Query failed: " .. parsed, vim.log.levels.ERROR)
				return
			end
			ts_query = parsed
		else
			vim.notify(("No textobjects query for language '%s'. Add one under after/queries/%s/textobjects.scm.")
				:format(lang, lang), vim.log.levels.WARN)
			return
		end
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

-- Map of key suffix to {capture_name, optional_fallback_query}
local query_map = {
	f = { "function.outer" },
	F = { "function.outer" },
	r = { "return.outer" },
	l = { "loop.outer" },
	c = { "comment.outer" },
	i = { "conditional.outer" },
	o = { "class.outer" },
	a = { "attribute.outer" },
	s = { "string" },
	I = { "integer" },
}

for key, data in pairs(query_map) do
	local capture, fallback = data[1], data[2]
	local command_name = "TSQF" .. key

	vim.api.nvim_create_user_command(command_name, function()
		query_to_qflist(capture, fallback)
	end, {})

	vim.keymap.set("n", "<Leader>m" .. key, function()
		vim.cmd(command_name)
	end, { desc = "TS query " .. capture .. " to quickfix" })
end

