local function setup_rose_pine()
	require("rose-pine").setup({
		variant = "auto",
		dark_variant = "moon",
		styles = {
			bold = true,
			italic = false,
			transparency = true,
		},

		palette = {
			moon = {
				base = "#1e1b2e",
				surface = "#1f1d2e",
				overlay = "#26233a",
				gold = "#e28b12",
				rose = "#d7827e",
				muted = "#6e6a86",
				sublte = "#9e9aba",
				iris = "#c4a7e7",
			},
		},
	})
end

local function setup_catppuccin()
	require("catppuccin").setup({
		flavour = "latte",
		transparent_background = false,
	})
end

local function setup_auto_dark_mode()
	require("auto-dark-mode").setup({
		update_interval = 3000,
		fallback = "dark",
		set_dark_mode = function()
			vim.api.nvim_set_option_value("background", "dark", {})
			vim.cmd.colorscheme("rose-pine-moon")
		end,
		set_light_mode = function()
			vim.api.nvim_set_option_value("background", "light", {})
			vim.cmd.colorscheme("catppuccin-latte")
		end,
	})
end

return {
	setup_rose_pine = setup_rose_pine,
	setup_catppuccin = setup_catppuccin,
	setup_auto_dark_mode = setup_auto_dark_mode,
}
