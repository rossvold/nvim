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
				["aa"] = "@parameter_actual.outer",
				["ia"] = "@parameter_actual.inner",
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
	max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
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
