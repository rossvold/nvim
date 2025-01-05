return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        { "j-hui/fidget.nvim", opts = {} }, -- Shows LSP activity on the bottom right
        "nvim-treesitter/nvim-treesitter-textobjects", -- Extends tresitter selection
        "stevearc/conform.nvim",
        "rust-lang/rust.vim",
    },

    config = function()
        require("rossvold.configs.lsp")
    end,
}
