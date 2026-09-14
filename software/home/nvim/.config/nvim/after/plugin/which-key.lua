if not require("utils.pack").loaded("which-key.nvim") then return end

local wk = require("which-key")
wk.add({
	{ "<leader>b", group = "buffer" },
	{ "<leader>d", group = "directory" },
	{ "<leader>f", group = "file" },
	{ "<leader>fd", group = "diff" },
	{ "<leader>g", group = "git" },
	{ "<leader>gc", group = "quickfix" },
	{ "<leader>gcl", group = "quickfix log" },
	{ "<leader>gl", group = "log" },
	{ "<leader>i", group = "ai" },
	{ "<leader>l", group = "lsp" },
	{ "<leader>p", group = "project" },
	{ "<leader>t", group = "tmux" },
	{ "<leader>v", group = "vim" },
	{ "<leader>y", group = "yank" },
	{ "gb", group = "global" },
	{ "gl", group = "repl" },
	{ "go", group = "sort" },
	{ "gs", group = "substitute" },
})
