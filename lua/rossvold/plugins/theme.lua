return {
	{
		"rose-pine/nvim",
		name = "rose-pine",
		config = function()
			require("rossvold.configs.theme").setup_rose_pine()
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("rossvold.configs.theme").setup_catppuccin()
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		dependencies = { "rose-pine/nvim", "catppuccin/nvim" },
		config = function()
			require("rossvold.configs.theme").setup_auto_dark_mode()
		end,
	},
}
