if not require("utils.pack").loaded("image.nvim") then return end

local image = require("image")

-- Still get an error when splitting with tmux
-- https://github.com/3rd/image.nvim/issues/106

image.setup({
	backend = "kitty",
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
	hijack_file_patterns = { "*.svg", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
})
