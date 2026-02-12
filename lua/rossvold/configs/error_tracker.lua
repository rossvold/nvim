local M = {}

-- Find project root (looks for .git, .hg, or just uses current directory)
local function find_project_root()
	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		current_file = vim.fn.getcwd()
	end
	local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
	local root = current_dir

	-- Try to find .git directory
	while root ~= "/" do
		local git_dir = root .. "/.git"
		if vim.fn.isdirectory(git_dir) == 1 or vim.fn.filereadable(git_dir) == 1 then
			return root
		end
		root = vim.fn.fnamemodify(root, ":h")
	end

	-- Fallback to current directory
	return current_dir
end

-- Get relative path from project root
local function get_relative_path(file_path, project_root)
	local full_path = vim.fn.fnamemodify(file_path, ":p")
	-- Normalize paths
	project_root = vim.fn.fnamemodify(project_root, ":p")

	-- Check if file is within project root
	if full_path:sub(1, #project_root) == project_root then
		local relative = full_path:sub(#project_root + 2) -- +2 to skip the trailing slash
		return relative
	end

	-- Fallback to relative from current directory
	return vim.fn.fnamemodify(file_path, ":.")
end

-- Read error tracker file and get next error number
local function get_next_error_number(project_root)
	local tracker_file = project_root .. "/error_tracker"
	local next_number = 1

	if vim.fn.filereadable(tracker_file) == 1 then
		local lines = vim.fn.readfile(tracker_file)
		for _, line in ipairs(lines) do
			-- Parse "Error: #X - <path>"
			local match = line:match("Error: #(%d+)")
			if match then
				local num = tonumber(match)
				if num and num >= next_number then
					next_number = num + 1
				end
			end
		end
	end

	return next_number
end

-- Append error to tracker file
local function append_error_to_tracker(project_root, error_number, file_path, description)
	local tracker_file = project_root .. "/error_tracker"
	local relative_path = get_relative_path(file_path, project_root)
	local line = string.format("Error: #%d - '%s' %s", error_number, description, relative_path)

	local file = io.open(tracker_file, "a")
	if file then
		file:write(line .. "\n")
		file:close()
	else
		vim.notify("Failed to write to error_tracker file", vim.log.levels.ERROR)
	end
end

-- Create a small floating window for Y/N prompt
local function show_yes_no_prompt(error_number, callback)
	local width = 20
	local height = 3
	local prompt_text = string.format("Error: #%d?", error_number)

	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prompt_text, "", "Y: yes  N: no" })

	-- Get current window dimensions
	local ui = vim.api.nvim_list_uis()[1]
	local win_width = ui.width
	local win_height = ui.height

	-- Calculate centered position
	local col = math.floor((win_width - width) / 2)
	local row = math.floor((win_height - height) / 2)

	-- Create floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "single",
		focusable = true,
	})

	-- Focus the window
	vim.api.nvim_set_current_win(win)

	-- Set keymaps
	vim.api.nvim_buf_set_keymap(buf, "n", "y", "", {
		callback = function()
			vim.api.nvim_win_close(win, false)
			vim.schedule(function()
				callback(true)
			end)
		end,
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "Y", "", {
		callback = function()
			vim.api.nvim_win_close(win, false)
			vim.schedule(function()
				callback(true)
			end)
		end,
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "n", "", {
		callback = function()
			vim.api.nvim_win_close(win, true)
			callback(false)
		end,
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "N", "", {
		callback = function()
			vim.api.nvim_win_close(win, true)
			callback(false)
		end,
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
		callback = function()
			vim.api.nvim_win_close(win, true)
			callback(false)
		end,
	})
end

-- Main function to add error
function M.add_error()
	-- Get current file and cursor position (save before opening floating window)
	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		vim.notify("No file open", vim.log.levels.WARN)
		return
	end

	-- Save current buffer and cursor position
	local original_buf = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = cursor_pos[1] - 1 -- 0-indexed
	local col = cursor_pos[2]

	-- Find project root
	local project_root = find_project_root()

	-- Get next error number
	local error_number = get_next_error_number(project_root)

	-- Show small Y/N prompt
	show_yes_no_prompt(error_number, function(yes)
		if yes then
			-- Switch back to original buffer immediately
			vim.api.nvim_set_current_buf(original_buf)
			-- Prompt for description
			vim.ui.input({
				prompt = string.format("Error: #%d description: ", error_number),
			}, function(description)
				if description and description ~= "" then
					-- Insert error at saved cursor position
					local current_line = vim.api.nvim_buf_get_lines(original_buf, line, line + 1, false)[1] or ""
					local error_text = string.format("Error #%d: ", error_number)
					local new_line = current_line:sub(1, col) .. error_text .. current_line:sub(col + 1)

					vim.api.nvim_buf_set_lines(original_buf, line, line + 1, false, { new_line })

					-- Move cursor after inserted text
					vim.api.nvim_win_set_cursor(0, { line + 1, col + #error_text })

					-- Append to tracker file with description
					append_error_to_tracker(project_root, error_number, current_file, description)

					vim.notify(string.format("Added Error: #%d", error_number), vim.log.levels.INFO)
				end
			end)
		end
	end)
end

-- Set keybind
vim.keymap.set("n", "<leader>e", M.add_error, { desc = "Add error tracker" })

return M
