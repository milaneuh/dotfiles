local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt


-- Helper function to check if text is selected
local function has_selection(snip)
	local selected = snip.env.TM_SELECTED_TEXT
	return selected and selected ~= ""
end

local snippets = {
	s("z", fmt("<Z sel='.{}'>\n  {}\n</Z>", { i(1, "css-class"), i(2, "<ChildrenZ/>") })),
	s("jz", fmt("<JSXZ sel='.{}' in='{}'>\n  {}\n</JSXZ>", { i(1, "css-class"), i(2, '"file"'), i(3, "") })),
	s("childZ", fmt("<ChildrenZ />", {})),
	s({ trig = "cl", dscr = "Console.log (works in visual or normal mode)" }, {
		f(function(args, snip)
			if has_selection(snip) then
				local selected = snip.env.TM_SELECTED_TEXT
				return selected .. "\nconsole.log(" .. selected .. ");"
			else
				return "console.log("
			end
		end),
		i(1),
		f(function(args, snip)
			return has_selection(snip) and "" or ");"
		end),
		i(0),
	}),
}

ls.add_snippets("javascript", snippets)
