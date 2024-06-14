-- Example if you want to clear all the builtin snippets
-- require("luasnip.session.snippet_collection").clear_snippets "elixir"

local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
    s("test", {
        t('print("hello '),
        i(1),
        t('world")'),
    })
})
