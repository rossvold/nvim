local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("go", {
    -- if err with return - cursor at return value
    s("ifer", fmt([[
if err != nil {{
		{errorhandling}
    return {returnerror}
}}]], {
        errorhandling = i(1, "//handle error"),
        returnerror = i(2, "err")
    })),

    -- if err with print and return err
    s("ifpr", fmt([[
if err != nil {{
    fmt.Println("Error: {message}", {error})
    return {returnerror}
}}]], {
        message = i(1, "message"),
        error = i(2, "err"),
        returnerror = i(3, "err")
    })),
})
