local function setup_rose_pine()
	require("rose-pine").setup({
		-- "auto" follows `background` / colorscheme so light uses stock dawn; dark uses `dark_variant`.
		variant = "auto",
		dark_variant = "moon", -- main, moon, or dawn
		styles = {
			bold = true,
			italic = false,
			transparency = true,
		},

		palette = {
			-- Override the builtin palette per variant
			moon = {
				base = "#1e1b2e", -- Base of main
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
			vim.cmd.colorscheme("rose-pine-dawn")
		end,
	})
end

return {
	setup_rose_pine = setup_rose_pine,
	setup_auto_dark_mode = setup_auto_dark_mode,
}
