require("oil").setup({
	default_file_explorer = true,
	columns = { "icon" },
	keymaps = {
		["<C-h>"] = false,
		["<M-h>"] = "actions.select_split",
	},
	view_options = {
		show_hidden = true,
	},
	win_options = {
		winbar = "%{v:lua.require('oil').get_current_dir()}",
	},
    float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
			winblend = 0,
        },
        preview_split = "right",
        override = function(conf)
            return conf
        end,
    },
})

vim.keymap.set("n", "<Leader>-", require("oil").toggle_float)
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
