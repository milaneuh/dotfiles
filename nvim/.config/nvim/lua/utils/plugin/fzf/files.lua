local M = {}

local config = require("utils.plugin.fzf.config")
local utils = require("utils.plugin.fzf.utils")

function M.directories(cwd)
	cwd = cwd or vim.fn.getcwd()
	require("fzf-lua").files({
		cmd = config.FIND_COMMANDS.DIRS,
		cwd = cwd,
		fzf_opts = {
			["--preview"] = "tree -C -L 1 {2}",
		},
		previewer = false,
		query = utils.get_visual_query(),
		actions = {
			["default"] = function(selected, opts)
				local fzf_path = require("fzf-lua.path")
				local entry = fzf_path.entry_to_file(selected[1], opts)
				local dir = entry.path
				if dir then
					vim.cmd("Explore " .. vim.fn.fnameescape(dir))
				end
			end,
		},
	})
end

function M.files(cwd)
	cwd = cwd or vim.fn.getcwd()
	require("fzf-lua").files({
		cmd = config.FIND_COMMANDS.FILES,
		cwd = cwd,
		fzf_opts = {
			["--preview"] = "bat --color=always --style=numbers {2}",
		},
		previewer = false,
		query = utils.get_visual_query(),
	})
end

function M.files_local()
	M.files(utils.get_current_dir())
end

function M.grep_local(cwd)
	cwd = cwd or utils.get_current_dir()
	require("fzf-lua").grep_project({ cwd = cwd, query = utils.get_visual_query() })
end

return M
