local ts = vim.treesitter

-- =============================================================================
-- Load treesitter highlights (Neovim core TS; no nvim-treesitter highlight = {})
-- Pattern must be real filetypes — "<filetype>" was a doc placeholder and matched nothing.
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
-- =============================================================================
-- QUERY TO QUICKFIX
-- =============================================================================
---@param filetype string
---@return string|nil
local function ft_to_lang(filetype)
	-- Use native nvim API to get language from filetype
	local ok, lang = pcall(vim.treesitter.language.get_lang, filetype)
	if ok and lang then
		return lang
	end
	-- Fallback: most filetypes are the same as language name
	return filetype
end

local function query_to_qflist(capture_name, fallback_query)
	local bufnr = vim.api.nvim_get_current_buf()
	local lang = ft_to_lang(vim.bo.filetype)
	if not lang then
		vim.notify("No treesitter language for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
		return
	end

	-- Check if parser exists
	local ok, parser = pcall(ts.get_parser, bufnr, lang)
	if not ok or not parser then
		vim.notify("No treesitter parser for language: " .. lang, vim.log.levels.WARN)
		return
	end

	local tree = parser:parse()[1]
	if not tree then
		vim.notify("Failed to parse tree for language: " .. lang, vim.log.levels.WARN)
		return
	end
	local root = tree:root()

	-- Prefer the language's installed/extended textobjects query from runtime (honors after/queries)
	local ts_query
	local get = vim.treesitter.query.get or vim.treesitter.query.get_query
	local ok_get, q = pcall(get, lang, "textobjects")
	if ok_get and q then
		-- Ensure the capture exists in this language
		local has_capture = false
		for _, name in pairs(q.captures or {}) do
			if name == capture_name then
				has_capture = true
				break
			end
		end
		if has_capture then
			ts_query = q
		else
			if fallback_query and #fallback_query > 0 then
				local ok_parse, parsed = pcall(ts.query.parse, lang, fallback_query)
				if not ok_parse then
					vim.notify("Query failed: " .. parsed, vim.log.levels.ERROR)
					return
				end
				ts_query = parsed
			else
				vim.notify(
					("Missing capture '%s' for language '%s'. Add it under after/queries/%s/textobjects.scm."):format(
						capture_name,
						lang,
						lang
					),
					vim.log.levels.WARN
				)
				return
			end
		end
	else
		-- No language textobjects query available; try fallback if provided
		if fallback_query and #fallback_query > 0 then
			local ok_parse, parsed = pcall(ts.query.parse, lang, fallback_query)
			if not ok_parse then
				vim.notify("Query failed: " .. parsed, vim.log.levels.ERROR)
				return
			end
			ts_query = parsed
		else
			vim.notify(
				("No textobjects query for language '%s'. Add one under after/queries/%s/textobjects.scm."):format(
					lang,
					lang
				),
				vim.log.levels.WARN
			)
			return
		end
	end

	local qflist = {}
	for id, node in ts_query:iter_captures(root, bufnr, 0, -1) do
		local name = ts_query.captures[id]
		if name == capture_name then
			local start_row, start_col = node:range()
			local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
			table.insert(qflist, {
				bufnr = bufnr,
				lnum = start_row + 1,
				col = start_col + 1,
				text = line,
			})
		end
	end

	if #qflist == 0 then
		vim.notify("No matches found for " .. capture_name, vim.log.levels.INFO)
	else
		vim.fn.setqflist(qflist, "r")
		vim.cmd("copen")
	end
end

-- Map of key suffix to {capture_name, optional_fallback_query}
local query_map = {
	f = { "function.outer" },
	r = { "return.outer" },
	l = { "loop.outer" },
	c = { "comment.outer" },
	i = { "conditional.outer" },
	o = { "class.outer" },
	s = { "string" },
	I = { "integer" },
	a = { "arguments" },
	p = { "parameters" },
	t = { "element_text" },
}
for key, data in pairs(query_map) do
	local capture, fallback = data[1], data[2]
	local command_name = "TSQF" .. key

	vim.api.nvim_create_user_command(command_name, function()
		query_to_qflist(capture, fallback)
	end, {})

	vim.keymap.set("n", "<Leader>m" .. key, function()
		vim.cmd(command_name)
	end, { desc = "TS query " .. capture .. " to quickfix" })
end

-- =============================================================================
-- INSPECT TREE TOGGLE
-- =============================================================================
local inspect_tree_buf = nil
vim.keymap.set("n", "<Leader>i", function()
	-- Check if InspectTree window is already open
	if inspect_tree_buf and vim.api.nvim_buf_is_valid(inspect_tree_buf) then
		-- Find and close the window containing this buffer
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == inspect_tree_buf then
				vim.api.nvim_win_close(win, true)
				inspect_tree_buf = nil
				return
			end
		end
		inspect_tree_buf = nil
	end
	-- Open InspectTree
	vim.cmd.InspectTree()
	-- Store the buffer number
	inspect_tree_buf = vim.api.nvim_get_current_buf()
end, { desc = "Toggle InspectTree" })
