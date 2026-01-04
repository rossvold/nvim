local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities()
end
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

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
	},
	handlers = {
		-- The first entry (without a key) will be the default handler and will be called for each installed server
		-- that doesn't have a dedicated handler.

		function(server_name) -- default handler (optional)
			vim.lsp.config[server_name] = {
				capabilities = capabilities,
			}
			vim.lsp.enable(server_name)
		end, -- Next, is targeted overrides for spesific servers.

		["lua_ls"] = function()
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
			vim.lsp.enable("lua_ls")
		end,

		["rust_analyzer"] = function()
			vim.lsp.config.rust_analyzer = {
				capabilities = capabilities,
			}
			vim.lsp.enable("rust_analyzer")
		end,

		["html"] = function()
			vim.lsp.config.html = {
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			}
			vim.lsp.enable("html")
		end,

		["htmx"] = function()
			vim.lsp.config.html = {
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			}
			vim.lsp.enable("html")
		end,

		["ts_ls"] = function()
			vim.lsp.config.ts_ls = {
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
			vim.lsp.enable("ts_ls")
		end,
	},
})

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
			vim.cmd.LspRestart()
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
