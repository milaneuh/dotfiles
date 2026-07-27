local M = {}

local bufutils = require("utils.buffers")

function M.get_visual_query()
	if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" then
		return bufutils.get_visual_selection()
	end
	return nil
end

function M.create_fzf_function(func_name)
	return function()
		require("fzf-lua")[func_name]({ query = M.get_visual_query() })
	end
end

function M.is_git_repo()
	return vim.fn.isdirectory(vim.fn.getcwd() .. "/.git") == 1
end

function M.get_current_dir()
	if bufutils.is_oil_buffer() then
		return require("utils.plugin.oil").get_current_dir()
	else
		return vim.fn.expand("%:p:h")
	end
end

return M
