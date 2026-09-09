local M = {}

local bufutils = require("utils.buffers")

local function strip_trailing_slash(path)
	return (path:gsub("(.)/$", "%1"))
end

local function oil_entry_path()
	local lnum = vim.fn.line(".")
	local paths = require("utils.plugin.oil").get_entry_paths(lnum, lnum)
	return paths[1]
end

local oil_modifiers = {
	[":p"] = "",
	[":p:h"] = ":h",
	[":t"] = ":t",
	[":."] = ":.",
	[":h"] = ":.:h",
}

local function resolve(modifier)
	if bufutils.is_oil_buffer() then
		local path = oil_entry_path()
		if path then
			local oil_modifier = oil_modifiers[modifier] or modifier
			if oil_modifier == "" then
				return path
			end
			return strip_trailing_slash(vim.fn.fnamemodify(path, oil_modifier))
		end
	end
	return vim.fn.expand("%" .. modifier)
end

local function yank(modifier, message)
	local expanded_path = resolve(modifier)
	vim.fn.setreg("+", expanded_path)
	vim.fn.setreg('"', expanded_path)

	if vim.env.TMUX then
		vim.fn.system("tmux set-buffer '" .. expanded_path:gsub("'", "'\\''") .. "'")
	end

	vim.print(message)
end

M.yank_file_name = function()
	yank(":t", "Yank File Name")
end

---@param with_file? boolean
M.yank_full_path = function(with_file)
	if with_file == false then
		yank(":p:h", "Yank Full Dir Path")
	else
		yank(":p", "Yank Full File Path")
	end
end

---@param with_file? boolean
M.yank_relative_path = function(with_file)
	if with_file == false then
		yank(":h", "Yank Relative Dir Path")
	else
		yank(":.", "Yank Relative File Path")
	end
end

M.yank_slack_markdown = function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local result = {}
	local in_code_block = false

	for _, line in ipairs(lines) do
		if line:match("^```") then
			if in_code_block then
				in_code_block = false
				table.insert(result, "```")
			else
				in_code_block = true
				table.insert(result, "```")
			end
		elseif in_code_block then
			table.insert(result, line)
		else
			-- Headers + Bold **text** / __text__ → placeholder to protect from italic pass
			line = line:gsub("^#+%s+(.+)$", "\001%1\001")
			line = line:gsub("%*%*(.-)%*%*", "\001%1\001")
			line = line:gsub("__(.-)__", "\001%1\001")
			-- Italic *text* → _text_
			line = line:gsub("%*(.-)%*", "_%1_")
			-- Restore bold as Slack bold *text*
			line = line:gsub("\001(.-)\001", "*%1*")
			-- Strikethrough ~~text~~ → ~text~
			line = line:gsub("~~(.-)~~", "~%1~")
			-- Bullet lists: "- " or "* " → "• "
			line = line:gsub("^(%s*)[-*]%s+", "%1• ")
table.insert(result, line)
		end
	end

	local slack_content = table.concat(result, "\n")
	vim.fn.setreg("+", slack_content)
	vim.fn.setreg('"', slack_content)

	if vim.env.TMUX then
		vim.fn.system("tmux set-buffer '" .. slack_content:gsub("'", "'\\''") .. "'")
	end

	vim.print("Yank Slack Markdown")
end

M.yank_file_content = function()
	vim.cmd("%y+")
	vim.fn.setreg('"', vim.fn.expand("%:p"))

	if vim.env.TMUX then
		local content = vim.fn.getreg("+")
		vim.fn.system("tmux set-buffer '" .. content:gsub("'", "'\\''") .. "'")
	end

	vim.print("Yank File Content")
end

M.yank_ref = function()
	local mode = vim.fn.mode()
	local path = resolve(":.")
	local result
	if mode == "v" or mode == "V" or mode == "\22" then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		result = "@" .. path .. "#" .. start_line .. "-" .. end_line
	else
		result = "@" .. path .. ":" .. vim.fn.line(".")
	end
	vim.fn.setreg("+", result)
	vim.fn.setreg('"', result)
	if vim.env.TMUX then
		vim.fn.system("tmux set-buffer '" .. result:gsub("'", "'\\''") .. "'")
	end
	vim.print(result)
end

M.yank_hotfix = function()
	local git_cmd = "git diff --name-only HEAD && git diff --name-only --cached"
	local modified_files = vim.fn.systemlist(git_cmd)

	if #modified_files == 0 then
		vim.print("No modified files found")
		return
	end

	local hotfix_content = {}

	for _, file in ipairs(modified_files) do
		if file ~= "" and vim.fn.filereadable(file) == 1 then
			local file_content = vim.fn.readfile(file)
			for _, line in ipairs(file_content) do
				table.insert(hotfix_content, line)
			end
		end
	end

	local final_content = table.concat(hotfix_content, "\n")

	vim.fn.setreg("+", final_content)
	vim.fn.setreg('"', final_content)

	if vim.env.TMUX then
		vim.fn.system("tmux set-buffer '" .. final_content:gsub("'", "'\\''") .. "'")
	end

	vim.print("Yanked hotfix content (" .. #modified_files .. " files)")
end

function M.remove_trailing_carriage(reg, mode)
	local content = vim.fn.getreg(reg)
	local adjusted

	if mode == "V" then
		adjusted = content:gsub("\n$", ""):gsub("$", "\n")
	else
		adjusted = content:gsub("\n$", "")
	end

	vim.fn.setreg("n", adjusted)
end

M.sanitise_visual_paste = function(reg, key)
	local mode = vim.fn.mode()
	if mode == "V" then
		M.remove_trailing_carriage(reg, mode)
		vim.cmd('normal! "nP')
	elseif mode == "v" then
		M.remove_trailing_carriage(reg, mode)
		vim.cmd('normal! "_c')
		if bufutils.is_visual_at_beginning_of_line() then
			vim.cmd('normal! "n')
		else
			vim.cmd('normal! "np')
		end
	else -- <C-V>
		vim.cmd("normal! A ")
		vim.cmd('normal! ""' .. key)
	end
	vim.cmd("clear")
end

return M
