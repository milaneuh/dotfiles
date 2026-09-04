if not require("utils.pack").loaded("nvim-treesitter") then return end

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local filetype = { "bash", "c", "elixir", "javascript", "lua", "markdown", "python", "vim", "vimdoc" }
require("nvim-treesitter").install(filetype)

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetype,
	callback = function()
		vim.treesitter.start()
	end,
})
