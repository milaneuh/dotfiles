if not require("utils.pack").loaded("oil.nvim") then return end

require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = false,
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
		["<C-p>"] = false,
		["zp"] = {
			"actions.preview",
			opts = { vertical = true, split = "belowright" },
			mode = "n",
			desc = "Preview entry in vertical split on the right",
		},
		["<F5>"] = { "actions.refresh", mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n", desc = "Toggle hidden files" },
		["gh"] = {
			"actions.select",
			opts = { horizontal = true, split = "belowright" },
			mode = "n",
			desc = "Open entry in horizontal split",
		},
		["gv"] = {
			"actions.select",
			opts = { vertical = true, split = "belowright" },
			mode = "n",
			desc = "Open entry in vertical split",
		},
	},
})

vim.keymap.set("n", "-", function()
	if vim.bo.buftype == "" and vim.bo.filetype ~= "fugitive" then
		require("oil").open()
	end
end, { noremap = true, silent = true, desc = "Open file explorer in current folder" })
