if not require("utils.pack").loaded("vim-tmux-navigator") then return end

local map = vim.keymap.set

map("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true, noremap = true, desc = "Navigate left (tmux/vim)" })
map("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { silent = true, noremap = true, desc = "Navigate down (tmux/vim)" })
map("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { silent = true, noremap = true, desc = "Navigate up (tmux/vim)" })
map("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { silent = true, noremap = true, desc = "Navigate right (tmux/vim)" })

map("n", "<M-h>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true, noremap = true, desc = "Navigate left (tmux/vim)" })
map("n", "<M-j>", "<Cmd>TmuxNavigateDown<CR>", { silent = true, noremap = true, desc = "Navigate down (tmux/vim)" })
map("n", "<M-k>", "<Cmd>TmuxNavigateUp<CR>", { silent = true, noremap = true, desc = "Navigate up (tmux/vim)" })
map("n", "<M-l>", "<Cmd>TmuxNavigateRight<CR>", { silent = true, noremap = true, desc = "Navigate right (tmux/vim)" })
