if not require("utils.pack").loaded("claudecode.nvim") then return end

require("claudecode").setup({
	auto_start = true,
	log_level = "warn",
	track_selection = true,
	focus_after_send = false,
	terminal = {
		provider = "none",
	},
})

local function get_claude_idx()
	local tmux = vim.fn.getenv("TMUX")
	if tmux == vim.NIL or tmux == "" then
		vim.notify("Claude: not in a TMUX session", vim.log.levels.WARN)
		return nil
	end
	local cwd = vim.fn.getcwd()
	local claude_name = "claude-" .. vim.fn.fnamemodify(cwd, ":t")
	local output = vim.fn.system(
		"tmux list-windows -F '#{window_index}|#{window_name}|#{pane_current_path}|#{pane_current_command}'"
	)
	for line in output:gmatch("[^\n]+") do
		local idx, name, path, cmd = line:match("^(%d+)|([^|]+)|([^|]+)|(.+)$")
		if path == cwd and (name == claude_name or cmd == "claude") then
			return idx
		end
	end
	return nil
end

local function get_sse_port()
	local ok, cc = pcall(require, "claudecode")
	if ok and cc.state and cc.state.port then
		return tostring(cc.state.port)
	end
	return nil
end

local function open_claude_window()
	local cwd = vim.fn.getcwd()
	local claude_name = "claude-" .. vim.fn.fnamemodify(cwd, ":t")
	local port = get_sse_port()
	local env_prefix = port and ("CLAUDE_CODE_SSE_PORT=" .. port .. " ") or ""
	vim.fn.system(
		"tmux new-window -a -n "
			.. vim.fn.shellescape(claude_name)
			.. " -c "
			.. vim.fn.shellescape(cwd)
			.. " '"
			.. env_prefix
			.. "claude --ide'"
	)
end

local function focus_claude_tmux()
	local idx = get_claude_idx()
	if idx then
		vim.fn.system("tmux select-window -t " .. idx)
	else
		open_claude_window()
	end
end

local function send_file_to_claude()
	local idx = get_claude_idx()
	if not idx then
		open_claude_window()
		return
	end
	local filepath = vim.fn.expand("%:p")
	if filepath ~= "" then
		vim.fn.system("tmux send-keys -t " .. idx .. " " .. vim.fn.shellescape("@" .. filepath) .. " ''")
	end
	vim.fn.system("tmux select-window -t " .. idx)
end

local function send_selection_to_claude()
	local line1 = math.min(vim.fn.line("."), vim.fn.line("v"))
	local line2 = math.max(vim.fn.line("."), vim.fn.line("v"))
	vim.schedule(function()
		local ok, sel = pcall(require, "claudecode.selection")
		if ok then
			sel.send_at_mention_for_visual_selection(line1, line2)
		end
		focus_claude_tmux()
	end)
end

vim.keymap.set("n", "<leader>ii", send_file_to_claude, { desc = "IA: Envoie fichier courant à Claude (tmux)" })
vim.keymap.set("x", "<leader>ii", send_selection_to_claude, { desc = "IA: Focus Claude (tmux) + send selection" })
vim.keymap.set("n", "<leader>if", focus_claude_tmux, { desc = "IA: Focus Claude tmux window" })
