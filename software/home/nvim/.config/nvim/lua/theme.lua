local M = {}

local state_file = (vim.env.XDG_STATE_HOME or vim.env.HOME .. "/.local/state") .. "/theme"

M.read = function()
	local file = io.open(state_file, "r")
	if not file then return "dark" end

	local value = file:read("l")
	file:close()

	return value == "light" and "light" or "dark"
end

M.apply = function()
	local variant = M.read()

	vim.o.background = variant
	vim.env.BAT_THEME = "gruvbox-" .. variant

	vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })
end

return M
