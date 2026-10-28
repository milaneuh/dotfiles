local M = {}

M.is_enabled = true

function M.start_with_images_disabled(image)
	image.disable()
	M.is_enabled = false
end

-- Workaround for kitty backend: the transmitted_images cache is not properly
-- cleared on disable, causing images to not render correctly on re-enable.
-- We force a deep (non-shallow) clear of all images before re-enabling.
function M.clear_images_before_reenabling(image)
	local images = image.get_images()
	for _, img in ipairs(images) do
		img:clear()
	end
end

function M.force_image_rendering()
	vim.defer_fn(function()
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })
		vim.api.nvim_exec_autocmds("CursorMoved", { buffer = 0 })
		vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = 0 })
		vim.cmd("redraw!")
	end, 100)
end

function M.disable_image_preview(image)
	image.disable()
	M.is_enabled = false
	vim.notify("Image display disabled", vim.log.levels.INFO)
end

function M.enable_image_preview(image)
	M.clear_images_before_reenabling(image)
	image.enable()
	M.is_enabled = true
	M.force_image_rendering()
	vim.notify("Image display enabled", vim.log.levels.INFO)
end

function M.toggle_image_preview(image)
	if M.is_enabled then
		M.disable_image_preview(image)
	else
		M.enable_image_preview(image)
	end
end

return M
