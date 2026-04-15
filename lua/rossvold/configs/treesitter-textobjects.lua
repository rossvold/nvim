-- luacheck: globals vim
---@diagnostic disable: undefined-global
-- NEW nvim-treesitter-textobjects config (main branch)
-- Rewritten for Neovim 0.12 - uses explicit keymaps instead of config tables

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

-- =============================================================================
-- SELECT (af, if, etc.)
-- =============================================================================

-- Function outer/inner
vim.keymap.set({ "x", "o" }, "af", function()
	select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select around function" })
vim.keymap.set({ "x", "o" }, "if", function()
	select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select inner function" })

-- Loop outer/inner
vim.keymap.set({ "x", "o" }, "al", function()
	select.select_textobject("@loop.outer", "textobjects")
end, { desc = "Select around loop" })
vim.keymap.set({ "x", "o" }, "il", function()
	select.select_textobject("@loop.inner", "textobjects")
end, { desc = "Select inner loop" })

-- Comment (both ac and ic do outer since there's no inner)
vim.keymap.set({ "x", "o" }, "ac", function()
	select.select_textobject("@comment.outer", "textobjects")
end, { desc = "Select around comment" })
vim.keymap.set({ "x", "o" }, "ic", function()
	select.select_textobject("@comment.outer", "textobjects")
end, { desc = "Select inner comment (same as outer)" })

-- Conditional outer/inner
vim.keymap.set({ "x", "o" }, "ai", function()
	select.select_textobject("@conditional.outer", "textobjects")
end, { desc = "Select around conditional" })
vim.keymap.set({ "x", "o" }, "ii", function()
	select.select_textobject("@conditional.inner", "textobjects")
end, { desc = "Select inner conditional" })

-- Class outer/inner
vim.keymap.set({ "x", "o" }, "ao", function()
	select.select_textobject("@class.outer", "textobjects")
end, { desc = "Select around class" })
vim.keymap.set({ "x", "o" }, "io", function()
	select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select inner class" })

-- Parameter inner/outer (your custom captures)
vim.keymap.set({ "x", "o" }, "iP", function()
	select.select_textobject("@parameter_actual.inner", "textobjects")
end, { desc = "Select inner parameter" })
vim.keymap.set({ "x", "o" }, "aP", function()
	select.select_textobject("@parameter_actual.outer", "textobjects")
end, { desc = "Select around parameter" })

-- Attribute inner/outer
vim.keymap.set({ "x", "o" }, "iA", function()
	select.select_textobject("@attribute.inner", "textobjects")
end, { desc = "Select inner attribute" })
vim.keymap.set({ "x", "o" }, "aA", function()
	select.select_textobject("@attribute.outer", "textobjects")
end, { desc = "Select around attribute" })

-- Return inner/outer
vim.keymap.set({ "x", "o" }, "ir", function()
	select.select_textobject("@return.inner", "textobjects")
end, { desc = "Select inner return" })
vim.keymap.set({ "x", "o" }, "ar", function()
	select.select_textobject("@return.outer", "textobjects")
end, { desc = "Select around return" })

-- =============================================================================
-- MOVE (mf, ml, mc, etc. - go to next)
-- =============================================================================

-- Function
vim.keymap.set({ "n", "x", "o" }, "mf", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Go to next function start" })

-- Loop
vim.keymap.set({ "n", "x", "o" }, "ml", function()
	move.goto_next_start("@loop.outer", "textobjects")
end, { desc = "Go to next loop start" })

-- Comment
vim.keymap.set({ "n", "x", "o" }, "mc", function()
	move.goto_next_start("@comment.outer", "textobjects")
end, { desc = "Go to next comment" })

-- Conditional
vim.keymap.set({ "n", "x", "o" }, "mi", function()
	move.goto_next_start("@conditional.outer", "textobjects")
end, { desc = "Go to next conditional" })

-- Assignment LHS (variable name)
vim.keymap.set({ "n", "x", "o" }, "mn", function()
	move.goto_next_start("@assignment.lhs", "textobjects")
end, { desc = "Go to next assignment LHS" })

-- Assignment RHS (variable value)
vim.keymap.set({ "n", "x", "o" }, "mv", function()
	move.goto_next_start("@assignment.rhs", "textobjects")
end, { desc = "Go to next assignment RHS" })

-- Class
vim.keymap.set({ "n", "x", "o" }, "mo", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Go to next class" })

-- Parameter outer
vim.keymap.set({ "n", "x", "o" }, "mp", function()
	move.goto_next_start("@parameter_actual.outer", "textobjects")
end, { desc = "Go to next parameter" })

-- Arguments
vim.keymap.set({ "n", "x", "o" }, "ma", function()
	move.goto_next_start("@arguments", "textobjects")
end, { desc = "Go to next arguments" })

-- HTML element text
vim.keymap.set({ "n", "x", "o" }, "mt", function()
	move.goto_next_start("@element_text", "textobjects")
end, { desc = "Go to next element text" })

-- HTML attribute
vim.keymap.set({ "n", "x", "o" }, "mA", function()
	move.goto_next_start("@attribute.outer", "textobjects")
end, { desc = "Go to next attribute" })

-- Return
vim.keymap.set({ "n", "x", "o" }, "mr", function()
	move.goto_next_start("@return.outer", "textobjects")
end, { desc = "Go to next return" })

-- Element start
vim.keymap.set({ "n", "x", "o" }, "me", function()
	move.goto_next_start("@element.start", "textobjects")
end, { desc = "Go to next element start" })

-- String
vim.keymap.set({ "n", "x", "o" }, "ms", function()
	move.goto_next_start("@string", "textobjects")
end, { desc = "Go to next string" })

-- Integer
vim.keymap.set({ "n", "x", "o" }, "mI", function()
	move.goto_next_start("@integer", "textobjects")
end, { desc = "Go to next integer" })

-- =============================================================================
-- MOVE (Mf, Ml, Mc, etc. - go to previous)
-- =============================================================================

-- Function
vim.keymap.set({ "n", "x", "o" }, "Mf", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Go to previous function start" })

-- Loop
vim.keymap.set({ "n", "x", "o" }, "Ml", function()
	move.goto_previous_start("@loop.outer", "textobjects")
end, { desc = "Go to previous loop start" })

-- Comment
vim.keymap.set({ "n", "x", "o" }, "Mc", function()
	move.goto_previous_start("@comment.outer", "textobjects")
end, { desc = "Go to previous comment" })

-- Conditional
vim.keymap.set({ "n", "x", "o" }, "Mi", function()
	move.goto_previous_start("@conditional.outer", "textobjects")
end, { desc = "Go to previous conditional" })

-- Assignment LHS
vim.keymap.set({ "n", "x", "o" }, "Mn", function()
	move.goto_previous_start("@assignment.lhs", "textobjects")
end, { desc = "Go to previous assignment LHS" })

-- Assignment RHS
vim.keymap.set({ "n", "x", "o" }, "Mv", function()
	move.goto_previous_start("@assignment.rhs", "textobjects")
end, { desc = "Go to previous assignment RHS" })

-- Class
vim.keymap.set({ "n", "x", "o" }, "Mo", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Go to previous class" })

-- Parameter outer
vim.keymap.set({ "n", "x", "o" }, "Mp", function()
	move.goto_previous_start("@parameter_actual.outer", "textobjects")
end, { desc = "Go to previous parameter" })

-- Arguments
vim.keymap.set({ "n", "x", "o" }, "Ma", function()
	move.goto_previous_start("@arguments", "textobjects")
end, { desc = "Go to previous arguments" })

-- HTML element text
vim.keymap.set({ "n", "x", "o" }, "Mt", function()
	move.goto_previous_start("@element_text", "textobjects")
end, { desc = "Go to previous element text" })

-- HTML attribute
vim.keymap.set({ "n", "x", "o" }, "MA", function()
	move.goto_previous_start("@attribute.outer", "textobjects")
end, { desc = "Go to previous attribute" })

-- Return
vim.keymap.set({ "n", "x", "o" }, "Mr", function()
	move.goto_previous_start("@return.outer", "textobjects")
end, { desc = "Go to previous return" })

-- Element start
vim.keymap.set({ "n", "x", "o" }, "Me", function()
	move.goto_previous_start("@element.start", "textobjects")
end, { desc = "Go to previous element start" })

-- String
vim.keymap.set({ "n", "x", "o" }, "Ms", function()
	move.goto_previous_start("@string", "textobjects")
end, { desc = "Go to previous string" })

-- Integer
vim.keymap.set({ "n", "x", "o" }, "MI", function()
	move.goto_previous_start("@integer", "textobjects")
end, { desc = "Go to previous integer" })

-- =============================================================================
-- SWAP
-- =============================================================================

vim.keymap.set("n", "<leader>l", function()
	swap.swap_next("@parameter.inner")
end, { desc = "Swap with next parameter" })

vim.keymap.set("n", "<leader>h", function()
	swap.swap_previous("@parameter.inner")
end, { desc = "Swap with previous parameter" })

-- =============================================================================
-- REPEATABLE MOVE ( ; and , for repeating moves)
-- =============================================================================

-- ensure , goes forward and ; goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_previous)

-- Export for LSP to use for diagnostic repeat
_G.ts_repeat_move = ts_repeat_move
