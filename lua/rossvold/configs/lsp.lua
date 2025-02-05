local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities()
end
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
local lspconfig = require("lspconfig")

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"gopls",
		"svelte",
		"ts_ls",
		"templ",
	},
	handlers = {
		-- The first entry (without a key) will be the default handler and will be called for each installed server
		-- that doesn't have a dedicated handler.

		function(server_name) -- default handler (optional)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end, -- Next, is targeted overrides for spesific servers.

		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = {
							globals = { "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				},
			})
		end,

		["rust_analyzer"] = function()
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = function()
					vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
				end,
			})
		end,

		["html"] = function()
			lspconfig.html.setup({
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})
		end,

		["htmx"] = function()
			lspconfig.html.setup({
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})
		end,

		["tailwindcss"] = function()
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				filetypes = { "templ", "svelte", "javascript", "typescript" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			})
		end,

		["ts_ls"] = function()
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				settings = {
					javascript = {
						inlayHints = {
							includeInlayEnumMemberValueHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
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
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayVariableTypeHints = false,
						},
					},
				},
			})
		end,
	},
})

vim.diagnostic.config({
	-- update_in_insert = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
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

local ibraGroup = vim.api.nvim_create_augroup("rossvold_worktree", {})

autocmd("LspAttach", {
	group = ibraGroup,
	callback = function(e)
		local opts = { buffer = e.buf }

		-- Instant actions
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, opts)
		vim.keymap.set("n", "gt", function()
			vim.lsp.buf.type_definition()
		end, opts)
		vim.keymap.set("n", "ga", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "gn", function()
			vim.lsp.buf.rename()
		end, opts)
		-- Display
		vim.keymap.set("n", "gl", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
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
		local next_diagnostic_repeat, prev_diagnostic_repeat =
			ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev) -- Makes moves repeatable
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next) -- moves regardless of the last direction
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_previous)
		vim.keymap.set({ "n", "x", "o" }, "md", next_diagnostic_repeat) -- Has to be below repeatable pair
		vim.keymap.set({ "n", "x", "o" }, "Md", prev_diagnostic_repeat)

		-- Keep for later
		-- Call Hierarchy to quickfix
		-- Not implemented in current lsp's Keep for future: vim.keymap.set("n", "grh", function() vim.lsp.buf.typehierarchy() end, opts)
		-- Dependant on above. vim.keymap.set("n", "grc", function() vim.lsp.buf.incoming_calls() end, opts)
		-- Dependant on above. vim.keymap.set("n", "gro", function() vim.lsp.buf.outgoing_calls() end, opts)
	end,
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
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
