if not require("utils.pack").loaded("vim-table-mode") then return end

vim.g.table_mode_disable_tableize_mappings = 1
vim.g.table_mode_map_prefix = "<LocalLeader>t"

vim.keymap.set("n", "yot", ":TableModeToggle<CR>", { noremap = true, desc = "Toggle table mode" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.cmd("TableModeEnable")
	end,
})
