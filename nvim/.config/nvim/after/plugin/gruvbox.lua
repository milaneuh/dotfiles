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

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "gruvbox",
	callback = function()
		vim.cmd([[ hi Normal guibg=NONE ctermbg=NONE ]])
		vim.cmd([[ hi NonText guibg=NONE ctermbg=NONE ]])
		vim.cmd([[ hi EndOfBuffer guibg=NONE ctermbg=NONE ]])
	end,
})

vim.cmd("colorscheme gruvbox")
