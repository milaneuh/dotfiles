local M = {}

local function raw_label(tabpage, tabnr)
	local tab_ok, custom_label = pcall(vim.api.nvim_tabpage_get_var, tabpage, "tablabel")
	if tab_ok and custom_label ~= "" then
		return custom_label
	end

	return tostring(tabnr)
end

M.tab_label = function(tabnr)
	local tabpage = vim.api.nvim_list_tabpages()[tabnr]
	if not tabpage then
		return "Invalid Tab"
	end

	local label = raw_label(tabpage, tabnr)

	if vim.fn.strchars(label) > 30 then
		label = vim.fn.strcharpart(label, 0, 29) .. "…"
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
	s = s .. "%{%v:lua.require('utils.buffers').bufferline()%}"
	s = s .. "%#TabLine#%999X[X]"
	return s
end

M.tab_rename = function(tablabel)
	local current_tabpage = vim.api.nvim_get_current_tabpage()
	vim.api.nvim_tabpage_set_var(current_tabpage, 'tablabel', tablabel)
	vim.cmd("redrawtabline")
end

return M
