local M = {}

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
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

	local tab_ok, tab_vars = pcall(function() return vim.api.nvim_tabpage_get_var(tabpage, 'tablabel') end)
	local custom_label = tab_ok and tab_vars or nil

	local label = ""

	if not custom_label or custom_label == "" then
		local buf_name = vim.api.nvim_buf_get_name(bufnr)
		if buf_name == "" then
			local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
			label = buftype == "" and "No Name" or ("<" .. buftype .. ">")
		else
			label = vim.fn.fnamemodify(buf_name, ":t")
			if buf_name:match("fugitive") and label == "" then
				label = "G status"
			elseif label == "" then
				label = "No Name"
			end
		end
	else
		label = custom_label
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
