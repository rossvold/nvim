-- TODO ADD COLORSCHEME TO TELESCOPE
-- Telescope
local actions = require "telescope.actions"
local builtin = require("telescope.builtin")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("git_worktree")

require("telescope").setup({
    defaults = {
			mappings = {
				i = {
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<C-w>"] = actions.smart_add_to_qflist + actions.open_qflist,
				},
				n = {
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<C-w>"] = actions.smart_add_to_qflist + actions.open_qflist,
				},
			},
	},
	file_ignore_patterns = {
		"node_modules",
		".svg",
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),
		},
	},
})

-- Keymaps
vim.keymap.set("n", "<leader>p", builtin.find_files, { desc = "[t]elescope []" })
vim.keymap.set("n", "<leader>tc", builtin.commands, { desc = "[t]elescope [c]ommands" })
vim.keymap.set("n", "<leader>tr", builtin.registers, { desc = "[t]elescope [r]egisters" })
vim.keymap.set("n", "<leader>td", builtin.diagnostics, { desc = "[t]elescope [d]iagnostics" })
vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "[t]elescope [h]elp" })
vim.keymap.set("n", "<leader>tgc", builtin.git_commits, { desc = "[t]elescope [g]it [c]ommits" })
vim.keymap.set("n", "<leader>tq", builtin.quickfix, { desc = "[t]elescope [q]uickfix" })
vim.keymap.set("n", "<leader>tQ", builtin.quickfixhistory, { desc = "[t]elescope [Q]uickfix history" })
vim.keymap.set("n", "<leader>tS", builtin.live_grep, { desc = "[t]elescope [S]earch live" })
vim.keymap.set("n", "<leader>tk", builtin.grep_string, { desc = "[t]telescope grep [k]eyword" })
vim.keymap.set("n", "<leader>ts", function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)
vim.keymap.set("n", "<leader>tgb", builtin.git_branches, { desc = "[t]elescope [g]it [b]ranches"})
vim.keymap.set("n", "<leader>tb", builtin.buffers, {})
vim.keymap.set("n", "<leader>tn", "<CMD>Telescope notify<CR>" )


vim.keymap.set("n", "<leader>tw", require("telescope").extensions.git_worktree.git_worktree, {
	desc = "[t]elescope [w]orktrees",
})
vim.keymap.set("n", "<leader>tW", require('telescope').extensions.git_worktree.create_git_worktree, {
	desc = "[t]elescope [W]orktrees",
})
