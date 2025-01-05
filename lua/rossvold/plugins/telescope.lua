return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},

	config = function()
		require("rossvold.configs.telescope")
	end,
}
