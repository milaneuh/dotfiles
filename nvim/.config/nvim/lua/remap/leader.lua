local M = {}

M.setup = function()
	local regutils = require("utils.registers")
	local winutils = require("utils.windows")
	local bufutils = require("utils.buffers")

	vim.g.mapleader = " "
	vim.g.maplocalleader = ","

	local function open_ranger_popup(directory)
		if vim.env.TMUX == nil or vim.env.TMUX == "" then
			vim.notify("Ranger could not be opened as not in TMUX session", vim.log.levels.WARN)
			return
		end

		-- TODO clean this mess
		local cmd = "tmux display-popup -d '%s' -w 90%% -h 90%% -E "
			.. "'ranger --choosefile=/tmp/rangerfile; "
			.. "if [ -f /tmp/rangerfile ]; then echo $(cat /tmp/rangerfile); fi'"
		vim.fn.system(string.format(cmd, directory))
		local chosen_file = vim.fn.system("cat /tmp/rangerfile 2>/dev/null"):gsub("\n", "")
		if chosen_file ~= "" and vim.fn.filereadable(chosen_file) == 1 then
			vim.cmd("edit " .. chosen_file)
			vim.fn.system("rm -f /tmp/rangerfile")
		end
	end

	local function open_lazygit_popup()
		if vim.env.TMUX == nil or vim.env.TMUX == "" then
			vim.notify("Lazygit could not be opened as not in TMUX session", vim.log.levels.WARN)
			return
		end

		local cmd = "tmux display-popup -d '%s' -w 90%% -h 90%% -E 'lazygit'"
		vim.fn.system(string.format(cmd, vim.fn.getcwd()))
	end

	local function generate_pdf_and_open()
		local filepath = vim.fn.expand("%:p")
		local filedir = vim.fn.expand("%:p:h")
		local filename = vim.fn.expand("%:t")
		local output = filepath:gsub("%.md$", ".pdf")

		vim.notify("Compiling PDF...", vim.log.levels.INFO)
		vim.fn.jobstart(
			string.format("md2pdf %s && xdg-open %s", filename, output),
			{ detach = true, cwd = filedir }
		)
	end

	-- Tmux splits
	vim.keymap.set(
		"n",
		"<leader>tt",
		":!tmux split-window -h -c %:p:h<tab> & <CR><CR>",
		{ noremap = true, silent = true, desc = "Create horizontal tmux split in file dir" }
	)
	vim.keymap.set(
		"n",
		"<leader>tv",
		":!tmux split-window -c %:p:h<tab> & <CR><CR>",
		{ noremap = true, silent = true, desc = "Create vertical tmux split in file dir" }
	)

	-- Tmux Repl
	vim.keymap.set(
		"n",
		"<leader>R",
		":!tmux split-window -hdb <CR><CR>",
		{ noremap = true, silent = true, desc = "Create tmux REPL split" }
	)

	-- Buffers
	vim.keymap.set("n", "<Leader>be", ":%bd|e#", { desc = "Delete all buffers except current" })
	vim.keymap.set("n", "<Leader>bb", ":b", { desc = "Switch to buffer" })
	vim.keymap.set("n", "<Leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Delete current buffer" })
	vim.keymap.set(
		"n",
		"<Leader>bt",
		":tabnew | e#<CR>",
		{ noremap = true, silent = true, desc = "Open alternate buffer in new tab" }
	)
	vim.keymap.set("n", "<Leader>bn", function()
		local dir = "/tmp/nvim_scratch"
		vim.fn.mkdir(dir, "p")
		local path = dir .. "/" .. os.date("%Y%m%d_%H%M%S") .. "_" .. math.random(1000, 9999) .. ".txt"
		vim.cmd("edit " .. path)
	end, { noremap = true, silent = true, desc = "Open new scratch buffer" })

	-- Directory
	vim.keymap.set("n", "<leader>dg", ':grep "" %:p:h<C-left><left><left>', { desc = "Grep in current file directory" })
	vim.keymap.set("v", "<leader>dg", "y:grep <C-R>0 %:p:h", { desc = "Grep selection in current file directory" })
	vim.keymap.set("n", "<leader>df", ":edit %:p:h<Tab><C-d>", { desc = "Open file in current file directory" })
	vim.keymap.set("n", "<leader>de", "", {
		noremap = true,
		desc = "Open ranger in current file directory",
		callback = function()
			open_ranger_popup(vim.fn.expand("%:p:h"))
		end,
	})

	-- File
	vim.keymap.set(
		"n",
		"<leader>fp",
		generate_pdf_and_open,
		{ noremap = true, silent = true, desc = "Generate PDF and open it" }
	)
	vim.keymap.set(
		"n",
		"<leader>fdg",
		":diffget<CR>",
		{ noremap = true, silent = true, desc = "Get diff changes from other file" }
	)
	vim.keymap.set(
		"n",
		"<leader>fdp",
		":diffput<CR>",
		{ noremap = true, silent = true, desc = "Put diff changes to other file" }
	)
	vim.keymap.set("n", "<leader>fg", ':lgrep "" %<C-left><left><left>', { desc = "Grep in current file" })
	vim.keymap.set("v", "<leader>fg", "y:lgrep <C-R>0 %", { desc = "Grep selection in current file" })

	-- Project
	vim.keymap.set("n", "<Leader>pT", ":tags<CR>", { desc = "Show tag stack" })
	vim.keymap.set("n", "<Leader>pf", ":find *", { desc = "Find file in project" })
	vim.keymap.set("n", "<Leader>pt", ":tag", { desc = "Jump to tag" })
	vim.keymap.set("n", "<leader>pg", ':grep ""<left>', { desc = "Grep in project" })
	vim.keymap.set("n", "<leader>ps", ":tags<CR>", { desc = "Show tag stack" })
	vim.keymap.set("v", "<leader>pg", "y:grep '<C-R>0'", { desc = "Grep selection in project" })
	vim.keymap.set("n", "<leader>pe", "", {
		noremap = true,
		desc = "Open ranger in project root",
		callback = function()
			open_ranger_popup(vim.fn.getcwd())
		end,
	})

	-- Yank
	vim.keymap.set("n", "<leader>yn", regutils.yank_file_name, { desc = "Yank file name" })
	vim.keymap.set("n", "<leader>yp", regutils.yank_full_path, { desc = "Yank full file path" })
	vim.keymap.set("n", "<leader>yP", function() regutils.yank_full_path(false) end, { desc = "Yank full dir path" })
	vim.keymap.set("n", "<leader>yr", regutils.yank_relative_path, { desc = "Yank relative file path" })
	vim.keymap.set("n", "<leader>yR", function() regutils.yank_relative_path(false) end, { desc = "Yank relative dir path" })
	vim.keymap.set("n", "<leader>yc", regutils.yank_file_content, { desc = "Yank entire file content" })
	vim.keymap.set("n", "<leader>ys", regutils.yank_slack_markdown, { desc = "Yank file content as Slack markdown" })
	vim.keymap.set("n", "<leader>yh", regutils.yank_hotfix, { desc = "Yank hotfix format" })
	vim.keymap.set({ "n", "v" }, "<leader>yi", regutils.yank_ref, { desc = "Yank file reference" })

	-- Git
	vim.keymap.set("n", "<leader>gD", ":DiffviewFileHistory %", { desc = "Show file history in diffview" })
	vim.keymap.set("n", "<Leader>G", open_lazygit_popup, { noremap = true, silent = true, desc = "Open lazygit popup" })

	-- Make
	vim.keymap.set("n", "<leader>m", ":make<cr><cr>", { desc = "Run make" })

	--  Tab
	vim.keymap.set("n", "<leader>>", ":+tabm<enter>", { desc = "Move tab right" })
	vim.keymap.set("n", "<leader><", ":-tabm<enter>", { desc = "Move tab left" })

	-- Execute selection in bash
	vim.keymap.set("v", "<leader>!", function()
		local selection = bufutils.get_visual_selection()
		vim.cmd("!" .. selection)
	end, { noremap = true, silent = true, desc = "Execute visual selection in bash" })

	-- Miscallenous
	vim.keymap.set("n", "<leader>F", winutils.toggle_quickfix_list, { desc = "Toggle quickfix list" })
	vim.keymap.set("n", "<leader>L", winutils.toggle_location_list, { desc = "Toggle location list" })

	-- Search
	vim.keymap.set(
		"n",
		"<leader>/",
		":noh<CR>:clear<CR>",
		{ noremap = true, silent = true, desc = "Clear search highlight" }
	)
	vim.keymap.set(
		"n",
		"<leader>fr",
		":FzfLua blines<CR>",
		{ noremap = true, silent = true, desc = "Search lines in current buffer" }
	)
end

return M
