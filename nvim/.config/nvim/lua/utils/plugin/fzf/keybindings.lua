local M = {}

local config = require("utils.plugin.fzf.config")
local utils = require("utils.plugin.fzf.utils")
local files = require("utils.plugin.fzf.files")
local git = require("utils.plugin.fzf.git")
local zettelkasten = require("utils.plugin.fzf.zettelkasten")
local navigation = require("utils.plugin.fzf.navigation")
local winutils = require("utils.windows")

local fzf_functions_to_add_visual = {
	{ func = "btags", mode = { "n", "v" }, remap = "<leader>ft", desc = "FZF: Find tags in current buffer" },
	{ func = "buffers", mode = { "n", "v" }, remap = "<leader>bb", desc = "FZF: Find open buffers" },
	{ func = "command_history", mode = { "n", "v" }, remap = "<leader>vh", desc = "FZF: Search command history" },
	{ func = "commands", mode = { "n", "v" }, remap = "<leader>vc", desc = "FZF: Search available commands" },
	{ func = "grep_project", mode = { "n", "v" }, remap = "<leader>pr", desc = "FZF: Grep in project" },
	{ func = "lines", mode = { "n", "v" }, remap = "<leader>br", desc = "FZF: Search lines in open buffers" },
	{
		func = "lsp_workspace_symbols",
		mode = { "n", "v" },
		remap = "<leader>lws",
		desc = "FZF: Find LSP workspace symbols",
	},
	{ func = "oldfiles", mode = { "n", "v" }, remap = "<leader>fh", desc = "FZF: Find recent files" },
	{ func = "tags", mode = { "n", "v" }, remap = "<leader>pt", desc = "FZF: Find project tags" },
	{ func = "tagstack", mode = { "n", "v" }, remap = "<leader>pk", desc = "FZF: Browse tag stack" },
	{ func = "zoxide", mode = { "n", "v" }, remap = "<leader>Z", desc = "FZF: Jump to directory with zoxide" },
	{ func = "helptags", mode = { "n", "v" }, remap = "<leader>vH", desc = "FZF: Search help tags" },
}

local additional_keymaps = {
	{ mode = { "n", "v" }, remap = "<leader>pd", func = files.directories, desc = "FZF: Find project directories" },
	{ mode = { "n", "v" }, remap = "<leader>pF", func = files.files, desc = "FZF: Find all project files" },
	{
		mode = { "n", "v" },
		remap = "<leader>pf",
		desc = "FZF: Find git/project files",
		func = function()
			if utils.is_git_repo() then
				require("fzf-lua").git_files({ query = utils.get_visual_query() })
			else
				require("fzf-lua").files({ query = utils.get_visual_query() })
			end
		end,
	},

	{
		mode = "n",
		remap = "<leader>dd",
		desc = "FZF: Find directories in current dir",
		func = function()
			files.directories(utils.get_current_dir())
		end,
	},
	{ mode = { "n", "v" }, remap = "<leader>df", func = files.files_local, desc = "FZF: Find files in current dir" },
	{ mode = { "n", "v" }, remap = "<leader>dr", func = files.grep_local, desc = "FZF: Grep in current dir" },

	{
		mode = "n",
		remap = "<leader>gwh",
		func = git.git_files_head,
		desc = "FZF: Find git files at HEAD",
	},
	{
		mode = "n",
		remap = "<leader>gwH",
		func = git.git_files_head_prev,
		desc = "FZF: Find git files at previous HEAD",
	},
	{ mode = { "n", "v" }, remap = "<leader>gs", func = require("fzf-lua").git_status, desc = "FZF: Git status" },

	{
		mode = { "n", "v" },
		remap = "<leader>z",
		func = navigation.zoxide_buffer,
		desc = "FZF: Jump to buffer dir with zoxide",
	},
}

function M.setup()
	for _, entry in ipairs(fzf_functions_to_add_visual) do
		local func_name = entry.func
		_G[func_name] = utils.create_fzf_function(func_name)
		vim.keymap.set(entry.mode, entry.remap, _G[func_name], { desc = entry.desc or ("FZF: " .. func_name) })
	end

	for _, entry in ipairs(additional_keymaps) do
		vim.keymap.set(entry.mode, entry.remap, entry.func, { desc = entry.desc })
	end

	for _, entry in ipairs(config.ZET_DIRS) do
		local name = entry.name or entry.prefix
		vim.keymap.set("n", "<leader>" .. entry.prefix .. "n", function()
			zettelkasten.k_new(entry.dir)
		end, { desc = "Zettelkasten: Create new " .. name .. " note" })
		vim.keymap.set({ "n", "x" }, "<leader>" .. entry.prefix .. "f", function()
			zettelkasten.k_find(entry.dir, entry.prefix)
		end, { desc = "Zettelkasten: Find " .. name .. " note" })
		vim.keymap.set({ "n", "x" }, "<leader>" .. entry.prefix .. "r", function()
			files.grep_local(entry.dir)
		end, { desc = "Zettelkasten: Grep in " .. name .. " notes" })
		vim.keymap.set("n", "<leader>" .. entry.prefix .. "t", function()
			local todo_path = vim.fn.fnamemodify(entry.dir .. "/" .. entry.todo, ":p")
			winutils.toggle_file_window(todo_path, entry.dir, entry.todo)
		end, { desc = "Zettelkasten: Toggle " .. name .. " TODO" })
	end
end

return M
