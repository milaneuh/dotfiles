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

local function in_tmux()
	if vim.env.TMUX == nil or vim.env.TMUX == "" then
		vim.notify("Claude: not in a TMUX session", vim.log.levels.WARN)
		return false
	end
	return true
end

local function tmux(...)
	return vim.system({ "tmux", ... }, { text = true }):wait()
end

local function claude_window_name()
	return "claude-" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

local function get_claude_target()
	local cwd = vim.fn.getcwd()
	local claude_name = claude_window_name()
	local res = tmux(
		"list-windows",
		"-F",
		"#{session_name}:#{window_index}|#{window_name}|#{pane_current_path}|#{pane_current_command}"
	)
	if res.code ~= 0 then
		return nil
	end
	for line in (res.stdout or ""):gmatch("[^\n]+") do
		local target, name, path, cmd = line:match("^([^|]+)|([^|]+)|([^|]+)|(.*)$")
		if target and path == cwd and (name == claude_name or cmd == "claude") then
			return target
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
	local port = get_sse_port()
	local env_prefix = port and ("CLAUDE_CODE_SSE_PORT=" .. port .. " ") or ""
	tmux("new-window", "-a", "-n", claude_window_name(), "-c", vim.fn.getcwd(), env_prefix .. "claude --ide")
end

local function focus_claude_tmux()
	if not in_tmux() then
		return
	end
	local target = get_claude_target()
	if target then
		tmux("select-window", "-t", target)
	else
		open_claude_window()
	end
end

local function send_file_to_claude()
	local filepath = vim.fn.expand("%:p")
	if filepath ~= "" then
		require("claudecode").send_at_mention(filepath, nil, nil, "keymap")
	end
	focus_claude_tmux()
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
