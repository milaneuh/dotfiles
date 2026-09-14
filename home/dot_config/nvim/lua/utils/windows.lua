local M = {}

M.is_window_present_in_current_tab = function(buftype_expected)
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buftype = vim.bo[buf].buftype
		if buftype == buftype_expected then
			return true
		end
	end
	return false
end

M.has_window_matching_pattern = function(pattern)
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		if name:match(pattern) then
			return true
		end
	end
	return false
end

M.toggle_quickfix_list = function()
	if M.is_window_present_in_current_tab("quickfix") then
		vim.cmd("cclose")
	else
		vim.cmd("botright copen")
	end
end

M.toggle_location_list = function()
	if M.is_window_present_in_current_tab("quickfix") then
		vim.cmd("lclose")
	else
		vim.cmd("botright lopen")
	end
end

M.fold_all_windows_and_come_back = function()
	local win_index = vim.fn.winnr()
	vim.cmd("windo set foldenable!")
	vim.cmd(win_index .. "wincmd w")
end

M.toggle_file_window = function(file_path, entry_dir, entry_file)
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name == file_path then
			vim.api.nvim_win_close(win, false)
			return
		end
	end
	local buffers = require("utils.buffers")
	if buffers.is_buffer_empty_and_unnamed() then
		vim.cmd("e " .. entry_dir .. "/" .. entry_file)
	else
		vim.cmd("botright vs")
		vim.cmd("e " .. entry_dir .. "/" .. entry_file)
	end
end


return M
