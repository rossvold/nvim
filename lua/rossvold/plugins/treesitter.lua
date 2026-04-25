return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		config = function()
			require("nvim-treesitter").install({
				"c",
				"rust",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"javascript",
				"typescript",
				"vue",
				"svelte",
				"zig",
			})
			-- Highlights: see lua/rossvold/treesitter.lua (FileType → vim.treesitter.start)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			require("rossvold.configs.treesitter-textobjects")
		end,
	},
	-- nvim-treesitter-context: still maintained, separate repo
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 3,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})
		end,
	},
}
