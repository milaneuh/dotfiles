local M = {}

local config = require("utils.plugin.fzf.config")
local utils = require("utils.plugin.fzf.utils")

function M.git_cmd(gitCmd)
	if utils.is_git_repo() then
		require("fzf-lua").git_files({
			cmd = gitCmd,
			query = utils.get_visual_query(),
		})
	else
		print("Not A Git Repository")
	end
end

function M.git_files_head()
	M.git_cmd(config.GIT_COMMANDS.HEAD)
end

function M.git_files_head_prev()
	M.git_cmd(config.GIT_COMMANDS.HEAD_PREV)
end

return M