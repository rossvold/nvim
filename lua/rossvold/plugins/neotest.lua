return {
	"nvim-neotest/neotest",
	dependencies = {
		"marilari88/neotest-vitest",
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
	},
	config = function()
		require("rossvold.configs.neotest")
	end,
}
