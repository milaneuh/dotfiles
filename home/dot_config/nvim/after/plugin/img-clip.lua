if not require("utils.pack").loaded("img-clip.nvim") then return end

require("img-clip").setup({
	filetypes = {
		markdown = {
			dir_path = ".",
			file_name = "%Y-%m-%d_%H-%M-%S",
		},
	},
})
