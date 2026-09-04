if not require("utils.pack").loaded("conform.nvim") then return end

-- Remember :
-- Format after SAVING for visual selection !!
-- It will format the old version if you don't.

local conform = require("conform")

conform.setup({
	formatters = {
		mix = { args = { "format", "-" } },
	},
	formatters_by_ft = {
		css = { "prettier" },
		elixir = { "mix" },
		html = { "prettier" },
		htmldjango = { "djlint" },
		javascript = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "black" },
		sh = { "shfmt" },
		xml = { "xmlformat" },
		go = { "golangci-lint" },
	},
})

vim.api.nvim_create_user_command("FormatFile", function()
	require("conform").format({ lsp_fallback = true, async = true })
end, {})

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Format file with conform" })

vim.o.formatexpr = "v:lua.require('conform').formatexpr({'timeout_ms':2000})"
