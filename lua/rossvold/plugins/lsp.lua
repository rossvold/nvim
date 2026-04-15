return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} }, -- Shows LSP activity on the bottom right
		"stevearc/conform.nvim",
		"rust-lang/rust.vim",
	},

	config = function()
		require("rossvold.configs.lsp")
	end,
}
