if not require("utils.pack").loaded("nvim-colorizer.lua") then return end

vim.opt.termguicolors = true

-- Attaches to every FileType mode
-- require("colorizer").setup()

require("colorizer").setup({
	"sh",
	"conf",
	"css",
	"html",
	"javascript",
	"lua",
})
