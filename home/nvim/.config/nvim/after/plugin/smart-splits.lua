if not require("utils.pack").loaded("smart-splits.nvim") then return end

local smart_splits = require("smart-splits")

smart_splits.setup({
	default_amount = 2,
	at_edge = "stop",
})

local function resize(direction)
	local axis = (direction == "left" or direction == "right") and { "h", "l" } or { "k", "j" }
	local current = vim.fn.winnr()
	if vim.fn.winnr(axis[1]) == current and vim.fn.winnr(axis[2]) == current then
		return
	end
	smart_splits["resize_" .. direction]()
end

local map = vim.keymap.set

map("n", "<C-h>", smart_splits.move_cursor_left, { silent = true, desc = "Navigate left (tmux/vim)" })
map("n", "<C-j>", smart_splits.move_cursor_down, { silent = true, desc = "Navigate down (tmux/vim)" })
map("n", "<C-k>", smart_splits.move_cursor_up, { silent = true, desc = "Navigate up (tmux/vim)" })
map("n", "<C-l>", smart_splits.move_cursor_right, { silent = true, desc = "Navigate right (tmux/vim)" })

map("n", "<M-h>", smart_splits.move_cursor_left, { silent = true, desc = "Navigate left (tmux/vim)" })
map("n", "<M-j>", smart_splits.move_cursor_down, { silent = true, desc = "Navigate down (tmux/vim)" })
map("n", "<M-k>", smart_splits.move_cursor_up, { silent = true, desc = "Navigate up (tmux/vim)" })
map("n", "<M-l>", smart_splits.move_cursor_right, { silent = true, desc = "Navigate right (tmux/vim)" })

map("n", "<C-Left>", function()
	resize("left")
end, { silent = true, desc = "Move window border left" })
map("n", "<C-Right>", function()
	resize("right")
end, { silent = true, desc = "Move window border right" })
map("n", "<C-Up>", function()
	resize("up")
end, { silent = true, desc = "Move window border up" })
map("n", "<C-Down>", function()
	resize("down")
end, { silent = true, desc = "Move window border down" })
