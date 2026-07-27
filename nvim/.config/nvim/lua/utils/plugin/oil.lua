local M = {}

function M.open(dir)
	if not require("utils.pack").loaded("oil.nvim") then
		vim.notify("Directory could not be opened as oil.nvim is not installed", vim.log.levels.ERROR)
		return
	end
	require("oil").open(dir)
end

function M.get_current_dir()
	if not require("utils.pack").loaded("oil.nvim") then
		vim.notify("Current directory is unknown as oil.nvim is not installed", vim.log.levels.ERROR)
		return nil
	end
	return require("oil").get_current_dir()
end

return M
