local M = {}

M.open_netrw_with_dash = function()
	if vim.bo.filetype == "netrw" then
		return
	end

	if vim.bo.filetype == "tagbar" then
		return
	end

	if vim.bo.filetype == "fugitive" then
		return
	end

	if vim.bo.filetype == "" then
		vim.keymap.set("n", "-", function()
			vim.cmd("Explore")
		end, { buffer = true, desc = "Open netrw" })
		return
	end

	if vim.bo.filetype ~= "netrw" then
		vim.keymap.set("n", "-", function()
			vim.fn.setreg("q", vim.fn.expand("%:t"))
			vim.cmd("Explore!")
			vim.cmd("normal! /" .. vim.fn.getreg("q") .. "\r")
		end, { buffer = true, desc = "Open netrw and locate current file" })
	end
end

return M
