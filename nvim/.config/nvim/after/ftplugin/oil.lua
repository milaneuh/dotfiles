local function current_dir()
	return require("oil").get_current_dir() or vim.fn.getcwd()
end
