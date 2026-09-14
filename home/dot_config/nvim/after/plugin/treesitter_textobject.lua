if not require("utils.pack").loaded("nvim-treesitter-textobjects") then return end

require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,

		lookahead = true,

		keymaps = {
			["af"] = "@function.outer",
			["ad"] = "@block.outer",
			["if"] = "@function.inner",
			["id"] = "@block.inner",
			["ac"] = "@class.outer",
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
		},
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
		},
		include_surrounding_whitespace = true,
	},
})
