local M = {}

local oil = require("utils.plugin.oil")
local utils = require("utils.plugin.fzf.utils")

function M.zoxide_buffer()
	require("fzf-lua").fzf_exec("zoxide query -l", {
		prompt = "Zoxide> ",
		actions = {
			["default"] = function(selected)
				oil.open(selected[1])
			end,
			["ctrl-t"] = function(selected)
				vim.cmd("tabnew")
				oil.open(selected[1])
			end,
		},
		query = utils.get_visual_query(),
	})
end

return M