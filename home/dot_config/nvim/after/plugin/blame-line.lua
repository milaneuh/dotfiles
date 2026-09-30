-- Inline blame for the line under the cursor, toggled on demand.
local ns = vim.api.nvim_create_namespace("blame_line")
local group = vim.api.nvim_create_augroup("BlameLine", { clear = true })
local enabled = false

local function show()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	local file = vim.api.nvim_buf_get_name(buf)
	if vim.bo[buf].buftype ~= "" or file == "" or vim.fn.filereadable(file) == 0 then return end

	-- ponytail: blames the saved file, so line numbers drift on a modified buffer
	local line = vim.fn.line(".")
	vim.system({
		"git", "-C", vim.fs.dirname(file), "blame", "--porcelain", "-L", line .. "," .. line, "--", file,
	}, { text = true }, vim.schedule_wrap(function(res)
		if res.code ~= 0 or not enabled then return end
		if not vim.api.nvim_buf_is_valid(buf) or vim.api.nvim_get_current_buf() ~= buf then return end
		if vim.fn.line(".") ~= line then return end

		local out = res.stdout
		local text
		if out:match("^0+%s") then
			text = "Not committed yet"
		else
			local author = out:match("\nauthor ([^\n]*)") or "?"
			local time = tonumber(out:match("\nauthor%-time (%d+)"))
			local summary = out:match("\nsummary ([^\n]*)") or ""
			text = ("%s, %s · %s"):format(author, time and os.date("%Y-%m-%d", time) or "?", summary)
		end

		vim.api.nvim_buf_set_extmark(buf, ns, line - 1, 0, {
			virt_text = { { "  " .. text, "Comment" } },
			virt_text_pos = "eol",
		})
	end))
end

local function toggle()
	enabled = not enabled
	vim.api.nvim_clear_autocmds({ group = group })
	if enabled then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { group = group, callback = show })
		show()
	else
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	end
	vim.notify("Line blame " .. (enabled and "on" or "off"))
end

vim.api.nvim_create_user_command("BlameLineToggle", toggle, { desc = "Git: Toggle inline blame for current line" })
vim.keymap.set("n", "<leader>gB", toggle, { desc = "Git: Toggle inline blame for current line" })
