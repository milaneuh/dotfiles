local M = {}


function M.search_outside_folds_next(direction)
	local pattern = vim.fn.getreg("/")
	if pattern == "" then
		print("No search pattern")
		return
	end

	local current_pos = vim.fn.getpos(".")
	local total_lines = vim.fn.line("$")
	local found = false

	if direction == 1 then -- forward
		local start_line = current_pos[2] + 1
		for i = start_line, total_lines do
			if vim.fn.foldclosed(i) == -1 then
				local line_content = vim.fn.getline(i)
				local match_col = vim.fn.match(line_content, pattern)
				if match_col >= 0 then
					vim.fn.cursor(i, match_col + 1)
					found = true
					break
				end
			end
		end
		if not found then
			for i = 1, current_pos[2] do
				if vim.fn.foldclosed(i) == -1 then
					local line_content = vim.fn.getline(i)
					local match_col = vim.fn.match(line_content, pattern)
					if match_col >= 0 then
						vim.fn.cursor(i, match_col + 1)
						found = true
						break
					end
				end
			end
		end
	else -- backward
		local start_line = current_pos[2] - 1
		for i = start_line, 1, -1 do
			if vim.fn.foldclosed(i) == -1 then
				local line_content = vim.fn.getline(i)
				local match_col = vim.fn.match(line_content, pattern)
				if match_col >= 0 then
					vim.fn.cursor(i, match_col + 1)
					found = true
					break
				end
			end
		end
		if not found then
			for i = total_lines, current_pos[2], -1 do
				if vim.fn.foldclosed(i) == -1 then
					local line_content = vim.fn.getline(i)
					local match_col = vim.fn.match(line_content, pattern)
					if match_col >= 0 then
						vim.fn.cursor(i, match_col + 1)
						found = true
						break
					end
				end
			end
		end
	end

	if not found then
		print("Pattern not found outside folds: " .. pattern)
	end
end

return M
