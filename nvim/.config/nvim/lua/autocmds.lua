local M = {}

M.setup = function()
	local bufutils = require("utils.buffers")

	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		callback = function()
			vim.cmd("clearjumps")
		end,
	})

	vim.api.nvim_create_autocmd("BufReadPost", {
		callback = function()
			bufutils.set_cursor_to_last_position()
		end,
	})

	vim.api.nvim_create_autocmd("BufWrite", {
		pattern = "*",
		callback = function()
			bufutils.remove_trailing_white_space()
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function()
			local filetype = vim.bo.filetype
			if filetype ~= "exs" then
				bufutils.trim_end_trailing_lines()
			end
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "elixir", "eelixir", "heex" },
		callback = function()
			vim.bo.makeprg = "mix compile"
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			local buf_path = vim.api.nvim_buf_get_name(0)
			if buf_path:match("zettelkasten") then
				vim.opt_local.spelllang = "fr"
			else
				vim.opt_local.spelllang = "en"
			end
		end,
	})
end

return M
