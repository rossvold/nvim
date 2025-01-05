require("notify").setup({
	timeout = 50,
	max_width = 45,
	background_colour = "NotifyBackground",
	fps = 30,
	render = "wrapped-compact",
	stages = "fade_in_slide_out",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T"
	},
	top_down = true
})

vim.notify = require("notify")
