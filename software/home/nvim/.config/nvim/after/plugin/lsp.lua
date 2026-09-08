if not require("utils.pack").loaded("nvim-lspconfig") then return end

vim.lsp.enable({
	"bashls",
	"cssls",
	"expert",
	"gopls",
	"html",
	"jinja_lsp",
	"jsonls",
	"lemminx",
	"lua_ls",
	"marksman",
	"pyright",
	"ts_ls",
})
