local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	  signs_staged_enable = true,
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
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
		map("n", "<leader>gR", gs.undo_stage_hunk)
		map("n", "<leader>gp", gs.preview_hunk)
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>gd", function()
			local has_gitsigns_diff_win = false
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
				local name = vim.api.nvim_buf_get_name(buf)
				if name:match("^gitsigns://") then
					has_gitsigns_diff_win = true
					break
				end
			end

			if vim.wo.diff or has_gitsigns_diff_win then
				vim.cmd("diffoff!")
				local current_win = vim.api.nvim_get_current_win()
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					local buf = vim.api.nvim_win_get_buf(win)
					local name = vim.api.nvim_buf_get_name(buf)
					if win ~= current_win and (vim.wo[win].diff or name:match("^gitsigns://")) then
						vim.api.nvim_win_close(win, false)
					end
				end
				return
			end
			gs.diffthis()
		end)
		map("n", "<leader>gx", gs.toggle_deleted)

		-- Text object
		--    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end,
})
