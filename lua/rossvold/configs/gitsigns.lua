local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
require("gitsigns").setup({
	signs = {
		add = { text = " +" },
		change = { text = " " },
		delete = { text = " 󰗨" },
		topdelete = { text = " ‾" },
		changedelete = { text = " ~" },
	},
	current_line_blame = false,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- repeat
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next)
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_previous)
		-- HAS TO BE AFTER REPEAT
		local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
		-- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

		vim.keymap.set({ "n", "x", "o" }, "mh", next_hunk_repeat)
		vim.keymap.set({ "n", "x", "o" }, "Mh", prev_hunk_repeat)
		-- Actions
		map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>gr", gs.undo_stage_hunk)
		map("n", "<leader>gp", gs.preview_hunk)
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>gd", gs.diffthis)
		map("n", "<leader>gx", gs.toggle_deleted)

		-- Text object
		--    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end,
})
