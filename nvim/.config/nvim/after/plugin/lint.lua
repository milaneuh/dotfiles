local loaded = require("utils.pack").loaded
if not require("utils.pack").loaded("nvim-lint") or loaded("mason-nvim-lint") then return end

local lint = require("lint")

lint.linters_by_ft = {
	elixir = { "credo" },
	javascript = { "eslint_d" },
	json = { "jq" },
	lua = { "luacheck" },
	shell = { "shellcheck" },
	typescript = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
