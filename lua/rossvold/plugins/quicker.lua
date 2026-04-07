return {
  'stevearc/quicker.nvim',
  ft = "qf",
  ---@module "quicker"
  opts = { },
	config = function()
		require("rossvold.configs.quicker")
	end,

}
