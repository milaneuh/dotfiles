local M = {}

local function raw_label(tabpage, bufnr)
	local tab_ok, custom_label = pcall(vim.api.nvim_tabpage_get_var, tabpage, "tablabel")
	if tab_ok and custom_label ~= "" then
		return custom_label
	end

	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	if buf_name == "" then
		local buftype = vim.bo[bufnr].buftype
		return buftype == "" and "No Name" or ("<" .. buftype .. ">")
	end

	local filename = vim.fn.fnamemodify(buf_name, ":t")
	if filename == "" then
		return buf_name:match("fugitive") and "G status" or "No Name"
	end

	return filename
end

M.tab_label = function(tabnr)
	local tabpage = vim.api.nvim_list_tabpages()[tabnr]
	if not tabpage then
		return "Invalid Tab"
	end

	local ok, win = pcall(vim.api.nvim_tabpage_get_win, tabpage)
	if not ok then
		return "Invalid Tab"
	end
	local bufnr = vim.api.nvim_win_get_buf(win)
	local modified = vim.bo[bufnr].modified

	local label = raw_label(tabpage, bufnr)

	if vim.fn.strchars(label) > 30 then
		label = vim.fn.strcharpart(label, 0, 29) .. "…"
	end

	if modified then
		label = label .. "*"
	end

	return label
end

M.tabline = function()
	local s = ""
	local current = vim.fn.tabpagenr()
	local total = vim.fn.tabpagenr("$")

	for i = 1, total do
		s = s .. ((i == current) and "%#TabLineSel#" or "%#TabLine#")
		s = s .. "%" .. i .. "T" .. "%{v:lua.require('utils.tabs').tab_label(" .. i .. ")} "
	end

	s = s .. "%#TabLineFill#%T%="
	s = s .. "%#TabLine#%999X[X]"
	return s
end

M.tab_rename = function(tablabel)
	local current_tabpage = vim.api.nvim_get_current_tabpage()
	vim.api.nvim_tabpage_set_var(current_tabpage, 'tablabel', tablabel)
	vim.cmd("redrawtabline")
end

return M
