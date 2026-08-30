if not require("utils.pack").loaded("vim-maximizer") then return end

vim.keymap.set("n", "<C-w>m", ":MaximizerToggle<CR>", {
	noremap = true,
	silent = true,
	desc = "Toggle window maximizer",
})
