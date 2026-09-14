if not require("utils.pack").loaded("nvim-autopairs") then return end

local npairs = require("nvim-autopairs")

npairs.setup({
	disable_filetype = { "markdown" },
})
