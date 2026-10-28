if not require("utils.pack").loaded("image.nvim") then return end

local image = require("image")
local image_preview = require("utils.image_preview")

image.setup({
	backend = "kitty", -- protocole kitty : ghostty le supporte, alacritty non
	processor = "magick_cli", -- pas de rock lua, juste imagemagick
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = false,
			only_render_image_at_cursor = true,
			filetypes = { "markdown" },
		},
	},
	max_height_window_percentage = 50,
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	editor_only_render_when_focused = true,
	tmux_show_only_in_active_window = true,
	hijack_file_patterns = {},
})

-- Désactivé par défaut hors ghostty, <leader>vi rebascule
if not require("utils.terminal").supports_graphics() then image_preview.start_with_images_disabled(image) end

vim.keymap.set("n", "<leader>vi", function()
	image_preview.toggle_image_preview(image)
end, { desc = "Vim: Toggle image rendering" })
