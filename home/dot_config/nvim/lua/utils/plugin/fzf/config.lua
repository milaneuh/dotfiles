local M = {}

local fzf_lua = require("fzf-lua")

M.PREVIEW_OPTIONS = {
	no_header = true,
}

M.BUFFERS_OPTIONS = {
	no_header = true,
	multiprocess = false, -- `buffers` crashes with multiprocess enabled
}

M.GIT_COMMANDS = {
	HEAD = 'git show --pretty="format:" --name-only HEAD',
	HEAD_PREV = 'git show --pretty="format:" --name-only HEAD~1',
}

M.FIND_COMMANDS = {
	DIRS = "find . -type d ",
	FILES = "find . -type f ",
}

local function shared_popup_size()
	local path = os.getenv("FZF_DEFAULT_OPTS_FILE") or (os.getenv("HOME") .. "/.config/fzf/fzf.conf")
	local conf = io.open(path)

	if not conf then return nil end

	local content = conf:read("*a")
	conf:close()

	return content:match("%-%-tmux[=%s]+(%S+)")
end

local function get_tmux_config()
	local popup_size = os.getenv("TMUX") and shared_popup_size()

	if popup_size then
		return "fzf-tmux", { ["--border"] = "rounded", ["--tmux"] = popup_size, ["--layout"] = "default" }
	else
		return "default", { ["--layout"] = "default" }
	end
end

function M.setup()
	local fzf_env, fzf_opts = get_tmux_config()

	fzf_lua.setup({
		[1] = fzf_env,
		fzf_opts = fzf_opts,
		fzf_colors = false,
		files = M.PREVIEW_OPTIONS,
		buffers = M.BUFFERS_OPTIONS,
		previewers = {
			tree = {
				cmd = "tree",
			},
		},
		grep = M.PREVIEW_OPTIONS,
		winopts = {
			preview = {
				layout = "vertical",
				vertical = "up:45%",
			},
			treesitter = {
				fzf_colors = false,
			},
		},
		hls = {
			titleflag = false,
		},
		actions = {
			files = {
				["default"] = fzf_lua.actions.file_edit,
				["ctrl-v"] = false,
				["ctrl-q"] = fzf_lua.actions.file_sel_to_qf,
				["ctrl-Q"] = fzf_lua.actions.file_sel_to_ll,
				["alt-i"] = fzf_lua.actions.toggle_ignore,
				["ctrl-h"] = fzf_lua.actions.toggle_hidden,
				["ctrl-f"] = fzf_lua.actions.toggle_follow,
			},
			buffers = {
				["default"] = fzf_lua.actions.buf_edit,
				["ctrl-v"] = false,
				["ctrl-q"] = fzf_lua.actions.file_sel_to_qf,
				["ctrl-Q"] = fzf_lua.actions.file_sel_to_ll,
				["alt-i"] = fzf_lua.actions.toggle_ignore,
				["ctrl-h"] = fzf_lua.actions.toggle_hidden,
				["ctrl-f"] = fzf_lua.actions.toggle_follow,
			},
		},
	})
end

return M
