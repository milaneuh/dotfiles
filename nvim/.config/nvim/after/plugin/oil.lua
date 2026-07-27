if not require("utils.pack").loaded("oil.nvim") then return end

require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
	},
	sort = {
		{ "type", "asc" },
		{ "mtime", "desc" },
	},
	keymaps = {
		["<C-h>"] = false,
		["<C-j>"] = false,
		["<C-k>"] = false,
		["<C-l>"] = false,
		["<C-s>"] = false,
		["<F5>"] = { "actions.refresh", mode = "n" },
		["<leader>h"] = { "actions.select", opts = { horizontal = true }, desc = "Open entry in horizontal split" },
		["<leader>v"] = { "actions.select", opts = { vertical = true }, desc = "Open entry in vertical split" },
	},
})

vim.keymap.set("n", "-", function()
	if vim.bo.buftype == "" and vim.bo.filetype ~= "fugitive" then
		require("oil").open()
	end
end, { noremap = true, silent = true, desc = "Open file explorer in current folder" })