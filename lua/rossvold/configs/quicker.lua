require("quicker").setup({
	opts = {
		buflisted = false,
		number = true,
		relativenumber = false,
		signcolumn = "auto",
		winfixheight = true,
		wrap = false,
	},

	constrain_cursor = false,
	trim_leading_whitespace = "common", -- How to trim the leading whitespace from results. Can be 'all', 'common', or false

	keys = {
		{
			">",
			function()
				require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
			end,
			desc = "Expand quickfix context",
		},
		{
			"<",
			function()
				require("quicker").collapse()
			end,
			desc = "Collapse quickfix context",
		},
	},

	type_icons = {
		E = "󰅚 ",
		W = "󰀪 ",
		I = " ",
		N = " ",
		H = " ",
	},

	highlight = {
		-- Use treesitter highlighting
		treesitter = true,
		-- Use LSP semantic token highlighting
		lsp = true,
		-- Load the referenced buffers to apply more accurate highlights (may be slow)
		load_buffers = true,
	},

	borders = { -- Border characters
		vert = "┃",
		-- Strong headers separate results from different files
		strong_header = "━",
		strong_cross = "╋",
		strong_end = "┫",
		-- Soft headers separate results within the same file
		soft_header = "╌",
		soft_cross = "╂",
		soft_end = "┨",
	},

	edit = {
		-- Enable editing the quickfix like a normal buffer
		enabled = true,
		-- Set to true to write buffers after applying edits.
		-- Set to "unmodified" to only write unmodified buffers.
		autosave = "true",
	},

	max_filename_width = function()
		return math.floor(math.min(95, vim.o.columns / 2))
	end,
	-- How far the header should extend to the right
	header_length = function(type, start_col)
		return vim.o.columns - start_col
	end,

	follow = {
    -- When quickfix window is open, scroll to closest item to the cursor
    enabled = false,
  },
})

-- Remap solves this also
-- vim.keymap.set("n", "<C-q>", function()
-- 	require("quicker").toggle()
-- end, { desc = "Toggle quickfix" })
