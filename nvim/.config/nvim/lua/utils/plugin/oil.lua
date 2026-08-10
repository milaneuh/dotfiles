local M = {}

local function strip_trailing_slash(path)
	return (path:gsub("(.)/$", "%1"))
end

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

function M.get_entry_paths(line_start, line_end)
	local dir = M.get_current_dir()
	if not dir then
		return {}
	end
	local oil = require("oil")
	local last = vim.api.nvim_buf_line_count(0)
	local paths = {}
	for lnum = math.max(line_start, 1), math.min(line_end, last) do
		local entry = oil.get_entry_on_line(0, lnum)
		if entry then
			table.insert(paths, strip_trailing_slash(dir .. entry.name))
		end
	end
	if #paths == 0 then
		return { strip_trailing_slash(dir) }
	end
	return paths
end

return M
