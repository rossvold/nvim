local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities()
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"gopls",
		"svelte",
		"ts_ls",
		"templ",
		"sqlls",
		"vue_ls",
	},
	automatic_enable = true, -- Mason-LSPConfig v2 auto-enables servers by default
})

-- Default handler
vim.lsp.config("*", {
	capabilities = capabilities,
	-- any custom settings...
})

vim.lsp.config.lua_ls = {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "Lua 5.1" },
			diagnostics = {
				globals = { "vim", "it", "describe", "before_each", "after_each" },
			},
		},
	},
}

vim.lsp.config.rust_analyzer = {
	capabilities = capabilities,
}

vim.lsp.config.html = {
	capabilities = capabilities,
	filetypes = { "html", "templ" },
}

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vim.fn.expand(
		"$HOME/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server"
	),
	languages = { "vue" },
}

vim.lsp.config.ts_ls = {
	capabilities = capabilities,
	init_options = {
		plugins = { vue_plugin },
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	on_attach = function(client)
		if vim.bo.filetype == "vue" then
			client.server_capabilities.semanticTokensProvider.full = false
		else
			client.server_capabilities.semanticTokensProvider.full = true
		end
	end,
	settings = {
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = false,
			},
		},
		typescript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = false,
			},
			tsserver = {
				exclude = { ".svelte-kit", ".svelte-kit/types/**/*" },
			},
		},
	},
	handlers = {
		["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			if result.diagnostics == nil then
				return
			end
			local idx = 1
			while idx <= #result.diagnostics do
				local entry = result.diagnostics[idx]
				if entry.code == 80001 then
					table.remove(result.diagnostics, idx)
				else
					idx = idx + 1
				end
			end
			pcall(function()
				require("ts-error-translator").translate_diagnostics(nil, result, ctx)
			end)
			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
		end,
	},
}

vim.lsp.config.vue_ls = {
	capabilities = capabilities,
	init_options = {
		vue_ls = {
			hybridMode = true,
		},
	},
}

vim.lsp.config.svelte = {
	capabilities = capabilities,
}

-- Add more vim.lsp.configs here

vim.diagnostic.config({
	-- update_in_insert = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "double",
		source = "always",
		header = "",
		prefix = "",
		max_width = 80,
		max_height = 20,
	},

	signs = {
		text = {
			-- Important to have atleast one space on the right of each icon!
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " 󰌵",
		},
	},
})

local autocmd = vim.api.nvim_create_autocmd

local rossGroup = vim.api.nvim_create_augroup("rossvold_worktree", {})

autocmd("LspAttach", {
	group = rossGroup,
	callback = function(e)
		local opts = { buffer = e.buf }

		-- Instant actions
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({
				focusable = true,
				border = "double",
				close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" },
				wrap = false,
			})
		end, opts)
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, opts)
		vim.keymap.set("n", "gT", function()
			vim.lsp.buf.type_definition()
		end, opts)
		vim.keymap.set("n", "ga", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "gn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("n", "<F5>", function()
			vim.cmd([[lsp restart]])
		end, opts)
		-- Display
		vim.keymap.set("n", "gl", function()
			vim.lsp.inlay_hint.enable()
		end, opts)

		-- Quickfix related actions are always starting with gr
		vim.keymap.set("n", "grr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "grw", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "grd", function()
			vim.lsp.buf.document_symbol()
		end, opts)
		vim.keymap.set("n", "gri", function()
			vim.lsp.buf.implementation()
		end, opts) -- Shows where things are implemented. Often time same as definition.

		-- Diagnostics
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)

		-- Use the global ts_repeat_move exported by treesitter-textobjects config
		-- This makes diagnostic jumps repeatable with , and ;
		-- Fallback if textobjects hasn't loaded yet
		vim.keymap.set({ "n", "x", "o" }, "md", vim.diagnostic.goto_next, opts)
		vim.keymap.set({ "n", "x", "o" }, "Md", vim.diagnostic.goto_prev, opts)
	end,
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
	},
	-- vim.keymap.set leader f to format
	vim.cmd("nnoremap <leader>f <cmd>lua require('conform').format()<CR>"),
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })
