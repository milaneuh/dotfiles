local M = {}

function M.get_zettelkasten_info()
	local buf_path = vim.fn.expand("%:p")
	local home = os.getenv("HOME")
	local zettelkasten_dir = home .. "/remoterepos/zettelkasten/notes"
	local zettelkasten_company_dir = home .. "/travail/zettelkasten_company"

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
