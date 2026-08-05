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

local function realpath(path)
	return vim.uv.fs_realpath(path) or path
end

local function contains(parent, child)
	return child == parent or child:sub(1, #parent + 1) == parent .. "/"
end

local function relative_to(base, path)
	if path == base then
		return "./"
	end
	if contains(base, path) then
		return path:sub(#base + 2)
	end
	return nil
end

local function nvim_cwd()
	return realpath(vim.fn.getcwd())
end

local function project_root()
	local cwd = nvim_cwd()
	local root = vim.fs.root(cwd, ".git")
	return root and realpath(root) or cwd
end

local function claude_window_name()
	return "claude-" .. vim.fn.fnamemodify(project_root(), ":t")
end

local function get_claude_target()
	local cwd, root = nvim_cwd(), project_root()
	local res = tmux(
		"list-windows",
		"-F",
		"#{session_name}:#{window_index}|#{window_name}|#{pane_current_path}|#{pane_current_command}"
	)
	if res.code ~= 0 then
		return nil
	end
	local best
	for line in (res.stdout or ""):gmatch("[^\n]+") do
		local target, name, path, cmd = line:match("^([^|]+)|([^|]+)|([^|]+)|(.*)$")
		if target and (name:match("^claude%-") or cmd == "claude") then
			path = realpath(path)
			if contains(path, cwd) and contains(root, path) and (not best or #path > #best.path) then
				best = { target = target, path = path }
			end
		end
	end
	return best
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
	local root = project_root()
	tmux("new-window", "-a", "-n", claude_window_name(), "-c", root, env_prefix .. "claude --ide")
end

local function focus_claude_tmux()
	if not in_tmux() then
		return
	end
	local target = get_claude_target()
	if target then
		tmux("select-window", "-t", target.target)
	else
		open_claude_window()
	end
end

local function fugitive_buffer_path(bufname)
	if vim.bo.filetype == "fugitive" then
		return nil, "Claude: pas de redirection depuis le statut fugitive (:G)"
	end
	local unavailable = "Claude: aucun fichier du disque associé à ce buffer fugitive"
	if vim.fn.exists("*FugitiveReal") == 0 then
		return nil, unavailable
	end
	local real = vim.fn.FugitiveReal(bufname)
	if real == "" or vim.fn.filereadable(real) == 0 then
		return nil, unavailable
	end
	return realpath(real)
end

local function current_buffer_path()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname:match("^fugitive://") then
		return fugitive_buffer_path(bufname)
	end
	local path = vim.fn.expand("%:p")
	if path == "" or (vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0) then
		return nil, "Claude: ce buffer n'a pas de fichier à envoyer"
	end
	return realpath(path)
end

local function mention_path_for(path, base)
	local mention = relative_to(base, path) or path
	if vim.fn.isdirectory(path) == 1 and not mention:match("/$") then
		mention = mention .. "/"
	end
	return mention
end

local broadcast_mention
broadcast_mention = function(mention, line_start, line_end, attempts)
	local cc = require("claudecode")
	if not (cc.state and cc.state.server) then
		vim.notify("Claude: serveur claudecode.nvim inactif", vim.log.levels.WARN)
		return
	end
	if cc.is_claude_connected() then
		cc.state.server.broadcast("at_mentioned", {
			filePath = mention,
			lineStart = line_start,
			lineEnd = line_end,
		})
		return
	end
	if attempts <= 0 then
		vim.notify("Claude: pas de session connectée, " .. mention .. " non envoyé", vim.log.levels.WARN)
		return
	end
	vim.defer_fn(function()
		broadcast_mention(mention, line_start, line_end, attempts - 1)
	end, 300)
end

local function send_to_claude(path, line_start, line_end)
	local tmux_ok = in_tmux()
	local target = tmux_ok and get_claude_target() or nil
	local base = target and target.path or project_root()
	broadcast_mention(mention_path_for(path, base), line_start, line_end, 30)
	if target then
		tmux("select-window", "-t", target.target)
	elseif tmux_ok then
		open_claude_window()
	end
end

local function send_file_to_claude()
	local path, err = current_buffer_path()
	if not path then
		vim.notify(err, vim.log.levels.WARN)
		return
	end
	send_to_claude(path, nil, nil)
end

local function send_selection_to_claude()
	local line1 = math.min(vim.fn.line("."), vim.fn.line("v"))
	local line2 = math.max(vim.fn.line("."), vim.fn.line("v"))
	local path, err = current_buffer_path()
	if not path then
		vim.notify(err, vim.log.levels.WARN)
		return
	end
	vim.schedule(function()
		send_to_claude(path, line1 - 1, line2 - 1)
	end)
end

vim.keymap.set("n", "<leader>ii", send_file_to_claude, { desc = "IA: Envoie fichier courant à Claude (tmux)" })
vim.keymap.set("x", "<leader>ii", send_selection_to_claude, { desc = "IA: Focus Claude (tmux) + send selection" })
vim.keymap.set("n", "<leader>if", focus_claude_tmux, { desc = "IA: Focus Claude tmux window" })
