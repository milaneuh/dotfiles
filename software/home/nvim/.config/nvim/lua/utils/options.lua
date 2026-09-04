local M = {}

M.toggle_color_column = function()
	if vim.o.colorcolumn == "" then
		vim.o.colorcolumn = "100"
	else
		vim.o.colorcolumn = ""
	end
end

M.toggle_hidden = function()
	if vim.o.hidden then
		vim.o.hidden = false
		vim.print("Hidden false")
	else
		vim.o.hidden = true
		vim.print("Hidden true")
	end
end

M.toggle_mouse = function()
	if vim.o.mouse ~= "" then
		vim.cmd("set mouse=")
	else
		vim.cmd("set mouse=nv")
	end
end

M.toggle_diagnostics = function()
	DIAGNOSTICS_ACTIVE = not DIAGNOSTICS_ACTIVE
	if DIAGNOSTICS_ACTIVE then
		print("Diagnostic Enable")
		vim.diagnostic.enable(true)
	else
		print("Diagnostic Disable")
		vim.diagnostic.enable(false)
	end
end

return M
