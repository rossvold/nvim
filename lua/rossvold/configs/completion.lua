require("rossvold.configs.snippets")

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")
lspkind.init({})

local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load() --Friendly snippets
luasnip.config.setup({})

local kind_formatter = lspkind.cmp_format({
	mode = "symbol_text",
	maxwidth = 50,
	ellipsis_char = "...",
	show_labelDetails = true, -- show labelDetails in menu. Disabled by default
	menu = {
		buffer = "[buf]",
		nvim_lsp = "[LSP]",
		nvim_lua = "[api]",
		path = "[path]",
		luasnip = "[snip]",
		gh_issues = "[issues]",
		tn = "[TabNine]",
		eruby = "[erb]",
	},
})

cmp.setup({
	preselect = cmp.PreselectMode.None,
	formatting = {
		fields = { "abbr", "kind", "menu" },
		expandable_indicator = true,
		format = function(entry, vim_item)
			-- Lspkind setup for icons
			vim_item = kind_formatter(entry, vim_item)

			return vim_item
		end,
	},

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered({
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "Normal:CmpMenu,FloatBorder:CmpBorder,CursorLine:CmpSel",
		}),
		documentation = cmp.config.window.bordered({
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "Normal:CmpDoc,FloatBorder:CmpBorder",
		}),
	},


	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),
	},

	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "supermaven" },
	}, {
			{ name = "buffer" },
		}),
})

-- Highlight groups for better visibility
vim.api.nvim_set_hl(0, "CmpBorder", {
	fg = "#6e6a86", -- muted color from rose-pine
	bg = "#1f1d2e", -- surface color from rose-pine
	ctermfg = 242,
	ctermbg = 235,
})

vim.api.nvim_set_hl(0, "CmpMenu", {
	bg = "#1f1d2e", -- surface color from rose-pine
	ctermbg = 235,
})

vim.api.nvim_set_hl(0, "CmpSel", {
	bg = "#26233a", -- overlay color from rose-pine
	fg = "#e0def4", -- text color
	ctermbg = 236,
	ctermfg = 15,
	bold = true,
})

vim.api.nvim_set_hl(0, "CmpDoc", {
	bg = "#1f1d2e", -- surface color from rose-pine
	ctermbg = 235,
})

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer", max_item_count = 10 },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			max_item_count = 5,
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})
