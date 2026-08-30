if not require("utils.pack").loaded("vim-fugitive") then return end

local utils = require("utils.plugin.fugitive")

vim.cmd([[autocmd FileType git setlocal foldmethod=syntax]])

vim.keymap.set("n", "<Leader>gd", ":Gvdiffsplit! !^", { desc = "Git: Diff with parent commit" })
vim.keymap.set("n", "<Leader>ge", ":Gedit ", { desc = "Git: Edit file at revision" })
vim.keymap.set("n", "<Leader>glG", ":Gclog --all -G''<left>", { desc = "Git: Log search inside commits" })
vim.keymap.set("n", "<Leader>glf", ":G log %", { desc = "Git: Log current file" })
vim.keymap.set("n", "<Leader>glg", ':Gclog --all --grep=""<left>', { desc = "Git: Log search commit messages" })
vim.keymap.set("n", "<Leader>gla", ':Gclog --author=""<left>', { desc = "Git: Log search commit messages" })
vim.keymap.set("n", "<Leader>gll", ":G log -1000", { desc = "Git: Log last 1000 commits" })
vim.keymap.set("n", "<Leader>gm", ":G blame <CR>", { desc = "Git: Blame current file" })
vim.keymap.set("n", "<Leader>gr", ":Ggrep", { desc = "Git: Grep in repository" })
vim.keymap.set("n", "<leader>gb", ":G branch", { desc = "Git: Manage branches" })
vim.keymap.set("n", "<leader>gclf", ":Gclog %", { desc = "Git: Quickfix log for current file" })
vim.keymap.set("n", "<leader>gcll", ":Gclog -1000", { desc = "Git: Quickfix log last 1000 commits" })
vim.keymap.set("x", "<leader>gl", ":Gclog", { desc = "Git: Quickfix log for selection" })

vim.keymap.set("n", "<leader>fdh", ":diffget //2 <CR>", { desc = "Git: Get diff from left (HEAD)" })
vim.keymap.set("n", "<leader>fdl", ":diffget //3 <CR>", { desc = "Git: Get diff from right (merge branch)" })

vim.keymap.set("n", "<leader>gg", utils.open_git_status, { noremap = true, silent = true, desc = "Git: Status" })

vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "diff",
	callback = utils.toggle_diagnostics_on_diff_change,
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = utils.disable_diagnostics_in_diff,
})

vim.keymap.set("n", "]p", function()
	utils.navigate_pending_file(1)
end, { desc = "Git: Next pending file" })
vim.keymap.set("n", "[p", function()
	utils.navigate_pending_file(-1)
end, { desc = "Git: Previous pending file" })
