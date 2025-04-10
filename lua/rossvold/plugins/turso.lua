return {
	{
		dir = "~/personal/turso-platform.nvim/",
		config = function()
			require("turso-platform").setup({
				vim.keymap.set("n", "<Leader>st", function()
					vim.cmd([[Turso]])
				end),
			})
		end,
	},
}
