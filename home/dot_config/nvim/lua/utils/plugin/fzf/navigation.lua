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

function M.buffers()
	local bufutils = require("utils.buffers")
	local alternate = vim.fn.bufnr("#")
	local entries = {}
	for i, bufnr in ipairs(bufutils.listed()) do
		local name = vim.api.nvim_buf_get_name(bufnr)
		name = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
		local flag = (bufnr == vim.api.nvim_get_current_buf() and "%") or (bufnr == alternate and "#") or " "
		table.insert(entries, string.format("%d: %s %s", i, flag, name))
	end

	require("fzf-lua").fzf_exec(entries, {
		prompt = "Buffers> ",
		actions = {
			["default"] = function(selected)
				bufutils.goto_nth(tonumber(selected[1]:match("^%d+")))
			end,
			["ctrl-t"] = function(selected)
				vim.cmd("tabnew")
				bufutils.goto_nth(tonumber(selected[1]:match("^%d+")))
			end,
		},
		query = utils.get_visual_query(),
	})
end

return M