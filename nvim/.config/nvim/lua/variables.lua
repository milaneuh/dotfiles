local M = {}

local function get_gnome_theme()
	if vim.env.XDG_CURRENT_DESKTOP and vim.env.XDG_CURRENT_DESKTOP:match("GNOME") then
		local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
		if handle then
			local gnome_theme = handle:read("*a"):gsub("%s+", "")
			handle:close()
			return gnome_theme
		end
	end
end

M.open_netrw_with_dash = function()
	vim.env.GNOME_THEME = get_gnome_theme()
end

return M
