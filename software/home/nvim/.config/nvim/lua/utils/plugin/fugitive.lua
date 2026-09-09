local M = {}

function M.disable_diagnostics_in_diff()
	if vim.wo.diff then
		vim.diagnostic.enable(false, { bufnr = 0 })
	end
end

function M.toggle_diagnostics_on_diff_change()
	vim.diagnostic.enable(not vim.v.option_new, { bufnr = 0 })
end

function M.open_git_status()
	local buf = vim.api.nvim_get_current_buf()
	local buf_name = vim.api.nvim_buf_get_name(buf)
	local modified = vim.bo[buf].modified
	local line_count = vim.api.nvim_buf_line_count(buf)
	local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
	vim.cmd("G")
	if buf_name == "" and not modified and line_count == 1 and first_line == "" then
		vim.cmd("only")
	end
end

function M.get_pending_files()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
	if vim.v.shell_error ~= 0 then
		return {}
	end
	local modified = vim.fn.systemlist("git diff --name-only HEAD 2>/dev/null")
	local untracked = vim.fn.systemlist("git ls-files --others --exclude-standard 2>/dev/null")
	local seen = {}
	local files = {}
	for _, file in ipairs(modified) do
		if file ~= "" and not seen[file] then
			seen[file] = true
			table.insert(files, git_root .. "/" .. file)
		end
	end
	for _, file in ipairs(untracked) do
		if file ~= "" and not seen[file] then
			seen[file] = true
			table.insert(files, git_root .. "/" .. file)
		end
	end
	return files
end

function M.navigate_pending_file(direction)
	local files = M.get_pending_files()
	if #files == 0 then
		vim.notify("No pending files", vim.log.levels.INFO)
		return
	end

	local current = vim.fn.expand("%:p")
	local current_idx = nil
	for i, file in ipairs(files) do
		if file == current then
			current_idx = i
			break
		end
	end

	local next_idx
	if current_idx == nil then
		next_idx = direction == 1 and 1 or #files
	else
		next_idx = current_idx + direction
		if next_idx > #files then
			next_idx = 1
		elseif next_idx < 1 then
			next_idx = #files
		end
	end

	vim.cmd("edit " .. vim.fn.fnameescape(files[next_idx]))
	vim.notify(string.format("Pending file %d/%d", next_idx, #files), vim.log.levels.INFO)
end

return M
