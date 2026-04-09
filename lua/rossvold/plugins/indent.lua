return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		indent = {
			char = "│",
			tab_char = "│",
		},
		whitespace = {
			remove_blankline_trail = true,
		},
		scope = {
			enabled = true,
			char = "│",
			show_start = true,
			show_end = true,
			include = {
				node_type = {
					["*"] = {
						"function",
						"function_definition",
						"method",
						"method_definition",
						"class",
						"class_definition",
						"if_statement",
						"for_statement",
						"while_statement",
						"try_statement",
						"with_statement",
						"switch_statement",
						"case_statement",
						"array",
					},
				},
			},
		},
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"lazy",
				"lspinfo",
				"TelescopePrompt",
				"TelescopeResults",
				"mason",
				"nvdash",
				"nvcheatsheet",
				"dashboard",
				"alpha",
			},
			buftypes = {
				"terminal",
				"nofile",
				"prompt",
			},
		},
	},
}
