local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
	s("null", fmt("> /dev/null 2>&1 ", {})),
}

ls.add_snippets("sh", snippets)
