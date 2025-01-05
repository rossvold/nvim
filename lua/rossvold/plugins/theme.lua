return {
	{ "EdenEast/nightfox.nvim" },
	{
		"rose-pine/nvim",
		name = "rose-pine",
		config = function()
		require("rossvold.configs.theme")
		end,
	},
	{ "luisiacc/gruvbox-baby" },
	{
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				style = "night",
				on_colors = function(colors)
					colors.border = "#ffffff"
				end,
			})
		end,
	},
	{ "loctvl842/monokai-pro.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
}
