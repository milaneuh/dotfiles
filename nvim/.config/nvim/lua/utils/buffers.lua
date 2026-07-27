local M = {}

function M.is_oil_buffer()
	return vim.bo.filetype == "oil"
end

function M.get_visual_selection()
	local current_mode = vim.api.nvim_get_mode().mode

	if current_mode == 'V' then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		local lines = vim.fn.getline(start_line, end_line)
		return table.concat(lines, '\n')
	elseif current_mode == 'v' then
		local start_pos = vim.fn.getpos("v")
		local end_pos = vim.fn.getpos(".")
		local start_row, start_col = start_pos[2], start_pos[3]
		local end_row, end_col = end_pos[2], end_pos[3]

		if start_row > end_row or (start_row == end_row and start_col > end_col) then
			start_row, end_row = end_row, start_row
			start_col, end_col = end_col, start_col
		end

		if start_row == end_row then
			local line = vim.fn.getline(start_row)
			return string.sub(line, start_col, end_col)
		else
			local lines = {}
			local first_line = vim.fn.getline(start_row)
			table.insert(lines, string.sub(first_line, start_col))

			for row = start_row + 1, end_row - 1 do
				table.insert(lines, vim.fn.getline(row))
			end

			local last_line = vim.fn.getline(end_row)
			table.insert(lines, string.sub(last_line, 1, end_col))

			return table.concat(lines, '\n')
		end
	else
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		local start_row = start_pos[2]
		local start_col = start_pos[3]
		local end_row = end_pos[2]
		local end_col = end_pos[3]

		if start_col == 1 and end_col == 2147483647 then
			local lines = vim.fn.getline(start_row, end_row)
			return table.concat(lines, '\n')
		else
			if start_row == end_row then
				local line = vim.fn.getline(start_row)
				return string.sub(line, start_col, end_col)
			else
				local lines = {}
				local first_line = vim.fn.getline(start_row)
				table.insert(lines, string.sub(first_line, start_col))

				for row = start_row + 1, end_row - 1 do
					table.insert(lines, vim.fn.getline(row))
				end

				local last_line = vim.fn.getline(end_row)
				table.insert(lines, string.sub(last_line, 1, end_col))

				return table.concat(lines, '\n')
			end
		end
	end
end

function M.is_visual_at_beginning_of_line()
	local start_pos = vim.fn.getpos("'<")
	local start_col = start_pos[3]

	if start_col == 1 then
		return true
	else
		return false
	end
end


function M.trim_end_trailing_lines()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local last_line = vim.fn.line("$")
	local last_nonblank_line = vim.fn.prevnonblank(last_line)
	if last_line > 0 and last_nonblank_line ~= last_line then
		vim.cmd(string.format("%d,$delete _", last_nonblank_line + 1))
		local new_last_line = vim.fn.line("$")
		if cursor_pos[1] > new_last_line then
			cursor_pos[1] = new_last_line
		end
		vim.api.nvim_win_set_cursor(0, cursor_pos)
	end
end


function M.remove_trailing_white_space()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd([[%s/\s\+$//e]])
	vim.api.nvim_win_set_cursor(0, cursor_pos)
end


function M.is_fugitive_buffer()
	local bufname = vim.api.nvim_buf_get_name(0)
	return bufname:match("^fugitive://") ~= nil
end

function M.set_cursor_to_last_position()
	local winutils = require("utils.windows")
	if M.is_fugitive_buffer() or winutils.has_window_matching_pattern("^fugitive://") then
		return
	end

	local mark = vim.api.nvim_buf_get_mark(0, '"')
	local line_count = vim.api.nvim_buf_line_count(0)
	if mark[1] > 0 and mark[1] <= line_count then
		vim.api.nvim_win_set_cursor(0, mark)
	end
end

function M.is_buffer_empty_and_unnamed(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local is_empty = vim.api.nvim_buf_line_count(bufnr) == 1
		and (vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or "") == ""
	local is_unnamed = vim.api.nvim_buf_get_name(bufnr) == ""
	local is_unmodified = not vim.bo[bufnr].modified
	return is_empty and is_unnamed and is_unmodified
end


return M
