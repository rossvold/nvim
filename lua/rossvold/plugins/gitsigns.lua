return {
	"lewis6991/gitsigns.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("rossvold.configs.gitsigns")
	end,
}
