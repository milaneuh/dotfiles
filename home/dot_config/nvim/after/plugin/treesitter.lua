if not require("utils.pack").loaded("nvim-treesitter") then return end

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local filetype = { "bash", "c", "elixir", "javascript", "lua", "markdown", "python", "templ", "vim", "vimdoc" }
-- go is only installed (not started) because templ injects it for Go expressions
require("nvim-treesitter").install(vim.list_extend({ "go" }, filetype))

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetype,
	callback = function()
		vim.treesitter.start()
	end,
})
