return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_turso_auth_token = os.getenv("TURSO_AUTH_TOKEN")  -- Load from environment variable
		vim.keymap.set("n", "<Leader>sq", function ()
			vim.cmd.tabnew()
			vim.cmd([[DBUI]])
		end )
	end,
}
