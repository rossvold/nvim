require("luasnip").filetype_extend("typescript", { "typescript" })
local fmt = require("luasnip.extras.fmt").fmt
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local isn = ls.indent_snippet_node

ls.add_snippets("typescript", {
	s("alerts", {
		isn(1, {
			t({
				'import alerts from "apialerts-js"',
				"const magpie_key = import.meta.env.VITE_MAGPIE; // Remember to double check that .env is set to VITE_MAGPIE",
				"alerts.setApiKey(magpie_key)",
			}),
		}, ""),
	}),

	s(
		"send",
		fmt(
			[[
const {notification} = {{
    message: '{message}',
    tags: ['{tag1}', '{tag2}'],
    link: '{link}',
}}
    alerts.send({notification})
    ]],
			{
				notification = i(1, "notification"),
				message = i(2, "message"),
				tag1 = i(3, "tag1"),
				tag2 = i(4, "tag2"),
				link = i(5, "https://"),
			},
			{
				repeat_duplicates = true,
			}
		)
	),

	s(
		"svelteload",
		fmt(
			[[
export const load: PageServerLoad = async () => {{
    {body}
    return {{
        {returns}
    }}
}}
    ]],
			{
				body = i(1, "// Your load function logic"),
				returns = i(2, "// Return values"),
			}
		)
	),

	s(
		"svelteactions",
		fmt(
			[[
export const actions: Actions = {{
		{default}: async ({{ request }}: RequestEvent) => {{
        {body}
        return {{
            {returns}
        }}
    }}
}}
    ]],
			{
				default = i(1, "default"),
				body = i(2, "// Your action logic"),
				returns = i(3, "// Return values"),
			}
		)
	),

	s(
		"pageserversvelte",
		fmt(
			[[
import type {{ Actions }} from "@sveltejs/kit"
import type {{ PageServerLoad }} from "../$types"

export const load: PageServerLoad = async () => {{
	{loadlogic}
	return {{
		// Return values
	 }}
}}

export const actions: Actions = {{
	{default}: async ({{}}) => {{
		{actionlogic}
		return {{
			// Return values
		}}
	}},
	// add more here
}}
    ]],
			{
				default = i(1, "default"),
				loadlogic = i(2, "// Your load function logic"),
				actionlogic = i(3, "// Your action function logic"),
			}
		)
	),
	-- Add more below
})
