local M = {}

local fzf_lua = require("fzf-lua")

M.PREVIEW_OPTIONS = {
	no_header = true,
	multiprocess = false, -- This make `buffers` crash now. Don't know why
}

M.GIT_COMMANDS = {
	HEAD = 'git show --pretty="format:" --name-only HEAD',
	HEAD_PREV = 'git show --pretty="format:" --name-only HEAD~1',
}

M.FIND_COMMANDS = {
	DIRS = "find . -type d ",
	FILES = "find . -type f ",
}

M.ZET_DIRS = {
	{ dir = os.getenv("zettelkasten"), prefix = "k", name = "personal", todo = "20250716233520.md" },
	{ dir = os.getenv("zettelkasten_company"), prefix = "c", name = "company", todo = "20250715102653.md" },
}

local function get_tmux_config()
	if os.getenv("TMUX") then
		return "fzf-tmux", { ["--border"] = "rounded", ["--tmux"] = "80%,80%", ["--layout"] = "default" }
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
		buffers = M.PREVIEW_OPTIONS,
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
				["ctrl-i"] = fzf_lua.actions.toggle_ignore,
				["ctrl-h"] = fzf_lua.actions.toggle_hidden,
				["ctrl-f"] = fzf_lua.actions.toggle_follow,
			},
			buffers = {
				["default"] = fzf_lua.actions.buf_edit,
				["ctrl-v"] = false,
				["ctrl-q"] = fzf_lua.actions.file_sel_to_qf,
				["ctrl-Q"] = fzf_lua.actions.file_sel_to_ll,
				["ctrl-i"] = fzf_lua.actions.toggle_ignore,
				["ctrl-h"] = fzf_lua.actions.toggle_hidden,
				["ctrl-f"] = fzf_lua.actions.toggle_follow,
			},
		},
	})
end

return M
