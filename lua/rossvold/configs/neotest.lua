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

vim.keymap.set("n", "<leader>tt", function()
	require("neotest").summary.toggle()
end, { desc = "Debug: Summary Toggle" })

-- vim.keymap.set("n", "tr", function()
-- 	require("neotest").run.run({ suite = false, testify = true })
-- end, { desc = "Debug: Running Nearest Test" })
--
-- vim.keymap.set("n", "ts", function()
-- 	require("neotest").run.run({ suite = true, testify = true })
-- end, { desc = "Debug: Running Test Suite" })
--
-- vim.keymap.set("n", "td", function()
-- 	require("neotest").run.run({ suite = false, testify = true, strategy = "dap" })
-- end, { desc = "Debug: Debug Nearest Test" })
--
-- vim.keymap.set("n", "to", function()
-- 	require("neotest").output.open()
-- end, { desc = "Debug: Open test output" })
--
-- vim.keymap.set("n", "ta", function()
-- 	require("neotest").run.run(vim.fn.getcwd())
-- end, { desc = "Debug: Open test output" })
--
