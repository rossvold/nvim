local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup()

-- Mappings
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>drc", dap.run_to_cursor)

vim.keymap.set("n", "<leader>dl", function()
	require("osv").launch({ port = 8086 })
end, { noremap = true })

-- Eval var under cursor
vim.keymap.set("n", "<leader>?", function()
	require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<leader>1", dap.continue)
vim.keymap.set("n", "<leader>2", dap.step_into)
vim.keymap.set("n", "<leader>3", dap.step_over)
vim.keymap.set("n", "<leader>4", dap.step_out)
vim.keymap.set("n", "<leader>5", dap.step_back)
vim.keymap.set("n", "<leader>6", dap.restart)

--   DEBUGGERS
dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

-- Go
-- Handled by nvim-dap-go
-- dap.adapters.go = {
--   type = "server",
--   port = "${port}",
--   executable = {
--     command = "dlv",
--     args = { "dap", "-l", "127.0.0.1:${port}" },
--   },
-- }

-- Elixir
-- local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
--   if elixir_ls_debugger ~= "" then
--     dap.adapters.mix_task = {
--       type = "executable",
--       command = elixir_ls_debugger,
--     }
--
--     dap.configurations.elixir = {
--       {
--         type = "mix_task",
--         name = "phoenix server",
--         task = "phx.server",
--         request = "launch",
--         projectDir = "${workspaceFolder}",
--         exitAfterTaskReturns = false,
--         debugAutoInterpretAllModules = false,
--       },
--     }
--   end

local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"svelte",
}

for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {
		-- Debug single nodejs files
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
		},
		-- Debug nodejs processes (make sure to add --inspect when you run the process)
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
		},
		-- Debug web applications (client side)
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Launch & Debug Chrome",
			url = function()
				local co = coroutine.running()
				return coroutine.create(function()
					vim.ui.input({
						prompt = "Enter URL: ",
						default = "http://localhost:3333",
					}, function(url)
						if url == nil or url == "" then
							return
						else
							coroutine.resume(co, url)
						end
					end)
				end)
			end,
			webRoot = vim.fn.getcwd(),
			protocol = "inspector",
			sourceMaps = true,
			userDataDir = false,
		},
	}
end

require("dap-vscode-js").setup({
	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
	-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
	-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
