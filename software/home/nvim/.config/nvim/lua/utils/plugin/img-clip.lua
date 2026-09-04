local M = {}

local function require_dir(name)
	local dir = os.getenv(name)

	if not dir then
		error("unset environment variable: " .. name)
	end

	if vim.fn.isdirectory(dir) == 0 then
		error("missing zettelkasten directory: " .. name .. "=" .. dir)
	end

	return dir
end

function M.get_zettelkasten_info()
	local buf_path = vim.fn.expand("%:p")
	local zettelkasten_dir = require_dir("zettelkasten")
	local zettelkasten_company_dir = require_dir("zettelkasten_company")

	local is_zettelkasten = string.find(buf_path, zettelkasten_dir, 1, true) or
		string.find(buf_path, zettelkasten_company_dir, 1, true)

	local current_dir = nil
	if is_zettelkasten then
		if string.find(buf_path, zettelkasten_dir, 1, true) then
			current_dir = zettelkasten_dir
		else
			current_dir = zettelkasten_company_dir
		end
	end

	return is_zettelkasten, current_dir
end

return M
