return {
  'stevearc/quicker.nvim',
  ft = "qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = { },
	config = function()
		require("rossvold.configs.quicker")
	end,

}
