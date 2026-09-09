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

local function hover_with_man_fallback()
	local word = vim.fn.expand("<cword>")

	local function open_man_page()
		if not pcall(vim.cmd.Man, word) then
			vim.notify("No documentation for " .. word, vim.log.levels.INFO)
		end
	end

	local client = vim.lsp.get_clients({ bufnr = 0, name = "bashls" })[1]
	if not client then return open_man_page() end

	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("textDocument/hover", params, function(err, result)
		if not err and result and result.contents then
			vim.lsp.buf.hover()
		else
			open_man_page()
		end
	end, 0)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.name == "bashls" then
			vim.keymap.set("n", "K", hover_with_man_fallback, {
				buffer = event.buf,
				desc = "Hover, falling back to man page",
			})
		end
	end,
})
