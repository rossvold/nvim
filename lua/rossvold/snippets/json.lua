local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("json", {
    s("vite", {
        t(' "debug": "NODE_OPTIONS=`--inspect` vite dev --port 3333 --open",'),
    })
})
