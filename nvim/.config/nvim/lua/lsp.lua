local M = {}

M.setup = function()
	require("lsp").setup()

	vim.lsp.enable("ts_ls")
	vim.lsp.enable("gopls")
	vim.lsp.enable("bashls")
	vim.lsp.enable("cssls")
	-- vim.lsp.enable("elixirls")
	vim.lsp.enable("expert")
	vim.lsp.enable("html")
	vim.lsp.enable("jsonls")
	vim.lsp.enable("marksman")
	vim.lsp.enable("pyright")
	vim.lsp.enable("vimls")
	vim.lsp.enable("lemminx")
	vim.lsp.enable("lua_ls")


	vim.api.nvim_create_user_command("DiagnosticsBuffer", function()
		vim.diagnostic.setloclist()
	end, {})

	vim.api.nvim_create_user_command("DiagnosticsProject", function()
		vim.diagnostic.setqflist()
	end, {})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
return M
