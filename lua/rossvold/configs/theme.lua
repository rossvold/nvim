require("rose-pine").setup({
	variant = "moon", -- auto, main, moon, or dawn
	dark_variant = "moon", -- main, moon, or dawn
	styles = {
		bold = true,
		italic = false,
		transparency = true,
	},

	palette = {
		-- Override the builtin palette per variant
		moon = {
			base = "#191724", -- Base of main
			surface = "#1f1d2e", -- Surface of main
			overlay = "#26233a", -- Overlay of main
			gold = "#e28b12",
			rose = "#d7827e", -- Rose of dawn
			muted = "#6e6a86",
			sublte = "#9e9aba",
			iris = "#c4a7e7",
		},
	},
})
vim.cmd("colorscheme rose-pine-moon")
