vim.keymap.set(
	"n",
	"<leader>%",
	":let $VIM_DIR=b:netrw_curdir<CR>:!tmux split-window -h -c $VIM_DIR<CR><CR>",
	{ buffer = true, silent = true, desc = "Create horizontal tmux split in netrw dir" }
)
vim.keymap.set(
	"n",
	'<leader>"',
	":let $VIM_DIR=b:netrw_curdir<CR>:!tmux split-window -c $VIM_DIR<CR><CR>",
	{ buffer = true, silent = true, desc = "Create vertical tmux split in netrw dir" }
)
vim.keymap.set("n", "<C-L>", ":noh<CR>:Explore<CR>", { buffer = true, silent = true, desc = "Clear highlight and refresh netrw" })
