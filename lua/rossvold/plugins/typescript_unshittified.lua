return {
	{
		"dmmulroy/tsc.nvim",
		lazy = true,
		ft = { "typescript" },
		config = function()
			require("tsc").setup({
				auto_open_qflist = true,
				pretty_errors = true,
				flags = "--noEmit --pretty false", -- This just works
				run_as_monorepo = true,
			})
		end,
	},
}
