if not require("utils.pack").loaded("tagbar") then return end

vim.g.tagbar_type_elixir = {
	ctagstype = "elixir",
	kinds = {
		"p:protocols",
		"m:modules",
		"e:exceptions",
		"y:types",
		"d:delegates",
		"f:functions",
		"c:callbacks",
		"a:macros",
		"t:tests",
		"i:implementations",
		"o:operators",
		"r:records",
	},
	sro = ".",
	kind2scope = {
		p = "protocol",
		m = "module",
	},
	scope2kind = {
		protocol = "p",
		module = "m",
	},
	sort = 0,
	excludekinds = { "z:trash" },
}

vim.g.tagbar_ctags_bin = "/usr/bin/ctags-universal"

vim.g.tagbar_sort = 0

-- Space is already my leader Key and K make more sense
vim.g.tagbar_map_showproto = "K"

-- Disable ctrl+p and ctrl+n
vim.g.tagbar_map_nexttag = ""
vim.g.tagbar_map_prevtag = ""

-- Differenciate the tags and the search colour
vim.cmd("highlight TagbarHighlight guibg=#CCCCCC guifg=#000000")

vim.keymap.set("n", "<leader>T", ":Tagbar<CR>", { noremap = true, desc = "Toggle Tagbar" })
vim.keymap.set("n", "]g", ':call tagbar#jumpToNearbyTag(1, "nearest")<CR>zz', {
	noremap = true,
	desc = "Jump to next nearby tag",
})
vim.keymap.set("n", "[g", ':call tagbar#jumpToNearbyTag(-1, "nearest")<CR>zz', {
	noremap = true,
	desc = "Jump to previous nearby tag",
})

function _G.TagbarIsOpen()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local bufname = vim.api.nvim_buf_get_name(buf)

		if string.find(bufname, "Tagbar") then
			return true
		end
	end
end
