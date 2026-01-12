require("neotest").setup({
	adapters = {
		require("neotest-vitest")({
			-- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
			filter_dir = function(name)
				return name ~= "node_modules"
			end,
		}),
	},
})

vim.keymap.set("n", "<leader>nt", function()
	require("neotest").summary.toggle()
end, { desc = "Summary Toggle" })

vim.keymap.set("n", "<leader>nr", function()
	require("neotest").run.run({ suite = false, testify = true })
end, { desc = "Running Nearest Test" })

vim.keymap.set("n", "<leader>ns", function()
	require("neotest").run.run({ suite = true, testify = true })
end, { desc = "Running Test Suite" })

vim.keymap.set("n", "<leader>nd", function()
	require("neotest").run.run({ suite = false, testify = true, strategy = "dap" })
end, { desc = "Debug Nearest Test" })

vim.keymap.set("n", "<leader>no", function()
	require("neotest").output.open()
end, { desc = "Open test output" })

vim.keymap.set("n", "<leader>na", function()
	require("neotest").run.run(vim.fn.getcwd())
end, { desc = "Open test output" })
