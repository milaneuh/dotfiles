local M = {}

--- Protocole graphique kitty : ghostty et kitty seulement.
--- @return boolean
function M.supports_graphics()
	return vim.env.GHOSTTY_RESOURCES_DIR ~= nil or vim.env.KITTY_WINDOW_ID ~= nil
end

return M
