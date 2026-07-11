if not require("utils.pack").loaded("LuaSnip") then return end

local ls = require("luasnip")

require("luasnip.loaders.from_snipmate").lazy_load()

require("luasnip").config.set_config({
	store_selection_keys = "<C-k>",
})

require("luasnip").filetype_extend("javascriptreact", { "javascript", "html" })

vim.keymap.set({ "i", "s" }, "<C-J>", function()
	ls.jump(-1)
end, { silent = true, desc = "Snippet: Jump to previous placeholder" })

vim.keymap.set({ "i", "s" }, "<C-K>", function()
	ls.jump(1)
end, { silent = true, desc = "Snippet: Jump to next placeholder" })

require("snippets.elixir")
require("snippets.bash")
require("snippets.javascript")
