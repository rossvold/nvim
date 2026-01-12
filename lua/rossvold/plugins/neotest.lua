return {
	"nvim-neotest/neotest",
	dependencies = {
		"marilari88/neotest-vitest",
	},
	config = function()
		require("rossvold.configs.neotest")
	end,
}
