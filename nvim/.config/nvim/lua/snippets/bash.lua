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
	s("null", fmt("> /dev/null 2>&1 ", {})),
}

ls.add_snippets("sh", snippets)
