if not require("utils.pack").loaded("gruvbox.nvim") then return end

require("gruvbox").setup({
	italic = {
		strings = false,
		emphasis = false,
		comments = false,
		operators = false,
		folds = false,
	},
})
vim.cmd("colorscheme gruvbox")
vim.cmd([[ hi Normal guibg=NONE ctermbg=NONE ]])
vim.cmd([[ hi NonText guibg=NONE ctermbg=NONE ]])
