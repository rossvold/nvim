local Hooks = require("git-worktree.hooks")
local config = require('git-worktree.config')
local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

Hooks.register(Hooks.type.SWITCH, function (path, prev_path)
	vim.notify("Moved from " .. prev_path .. " to " .. path)
	update_on_switch(path, prev_path) -- Updates current working directory.
	-- You might be using oil or neotree etc, then your working directory will be set,
	-- without your filetree buffer updating. You have to handle that yourself.
	-- Oil.nvim configuration
	if vim.fn.expand("%"):find("^oil:///") then
		require("oil").open(vim.fn.getcwd())
	end
end)

Hooks.register(Hooks.type.DELETE, function ()
	vim.cmd(config.update_on_change_command)
end)
