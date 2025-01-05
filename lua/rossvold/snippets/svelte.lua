require'luasnip'.filetype_extend("typescript", {"typescript"})
local fmt = require("luasnip.extras.fmt").fmt


local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local isn = ls.indent_snippet_node

ls.add_snippets("svelte", {
    s("comment", {
        t('<!--'),
        i(1),
        t('-->'),
    }),
	s("meta", fmt([[
<!--50-60, not verbose or vague-->
<title>{title}</title>
<!-- Meta description, should always be less than 160 characters-->
	<meta
		name="description"
		content="{content}" />
	<!-- Unfollow means we don't vouch for the links on this page-->
	<meta
		name="robots"
		content="{index}, {follow}"/>
	]], {
			title = i(1, "title"),
			content = i(2, "content"),
			index = i(3, "index"),
			follow = i(4, "follow"),
		},
		{
			repeat_duplicates = true
		})),
})


