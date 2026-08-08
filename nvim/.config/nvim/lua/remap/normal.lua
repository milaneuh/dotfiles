local M = {}

M.setup = function()
	local winutils = require("utils.windows")
	local optutils = require("utils.options")
	local foldutils = require("utils.fold")

	-- Remaps: Brackets ------------------------------------------------------------

	vim.keymap.set("n", "]B", ":blast<CR>", { noremap = true, silent = true, desc = "Go to last buffer" })
	vim.keymap.set("n", "]F", ":clast<CR>", { noremap = true, silent = true, desc = "Go to last quickfix item" })
	vim.keymap.set("n", "[L", ":lfirst<CR>", { noremap = true, silent = true, desc = "Go to first location list item" })
	vim.keymap.set("n", "]T", ":tlast<CR>", { noremap = true, silent = true, desc = "Go to last tag" })
	vim.keymap.set("n", "[B", ":bfirst<CR>", { noremap = true, silent = true, desc = "Go to first buffer" })
	vim.keymap.set("n", "[F", ":cfirst<CR>", { noremap = true, silent = true, desc = "Go to first quickfix item" })
	vim.keymap.set("n", "]L", ":llast<CR>", { noremap = true, silent = true, desc = "Go to last location list item" })
	vim.keymap.set("n", "[Q", ":cfirst<CR>", { noremap = true, silent = true, desc = "Go to first quickfix item" })
	vim.keymap.set("n", "[T", ":tfirst<CR>", { noremap = true, silent = true, desc = "Go to first tag" })

	vim.keymap.set("n", "[b", ":bp<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })
	vim.keymap.set("n", "[f", ":cp<CR>zz", { noremap = true, silent = true, desc = "Go to previous quickfix item" })
	vim.keymap.set(
		"n",
		"[l",
		":lprevious<CR>",
		{ noremap = true, silent = true, desc = "Go to previous location list item" }
	)
	vim.keymap.set("n", "[t", ":pop<CR>zz", { noremap = true, silent = true, desc = "Pop tag stack" })
	vim.keymap.set("n", "[z", "zk", { noremap = true, silent = true, desc = "Move to start of previous fold" })
	vim.keymap.set("n", "]b", ":bn<CR>", { noremap = true, silent = true, desc = "Go to next buffer" })
	vim.keymap.set("n", "]f", ":cn<CR>zz", { noremap = true, silent = true, desc = "Go to next quickfix item" })
	vim.keymap.set("n", "]l", ":lnext<CR>", { noremap = true, silent = true, desc = "Go to next location list item" })
	vim.keymap.set("n", "]t", ":ta<CR>zz", { noremap = true, silent = true, desc = "Jump to tag" })
	vim.keymap.set("n", "]z", "zj", { noremap = true, silent = true, desc = "Move to start of next fold" })

	-- Remap: Ergonomy ------------------------------------------------------------

	vim.keymap.set("", "<F1>", "<Nop>", { noremap = true, silent = true, desc = "Disable F1 help" })
	vim.keymap.set("n", "Y", "v$hy", { noremap = true, silent = true, desc = "Yank to end of line" })
	vim.keymap.set("n", "zC", "zxzc", { noremap = true, silent = true, desc = "Close all folds under cursor" })
	vim.keymap.set("n", "zh", "30zh", { noremap = true, silent = true, desc = "Scroll 30 chars left" })
	vim.keymap.set("n", "zl", "30zl", { noremap = true, silent = true, desc = "Scroll 30 chars right" })
	vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Navigate left" })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Navigate down" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Navigate up" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Navigate right" })
	vim.keymap.set("n", "<C-Left>", "2<C-w><", { noremap = true, silent = true, desc = "Decrease window width" })
	vim.keymap.set("n", "<C-Right>", "2<C-w>>", { noremap = true, silent = true, desc = "Increase window width" })
	vim.keymap.set("n", "<C-Up>", "2<C-w>-", { noremap = true, silent = true, desc = "Decrease window height" })
	vim.keymap.set("n", "<C-Down>", "2<C-w>+", { noremap = true, silent = true, desc = "Increase window height" })
	vim.keymap.set("n", "<C-S-h>", "<C-w>H", { noremap = true, silent = true, desc = "Move window to far left" })
	vim.keymap.set("n", "<C-S-j>", "<C-w>J", { noremap = true, silent = true, desc = "Move window to bottom" })
	vim.keymap.set("n", "<C-S-k>", "<C-w>K", { noremap = true, silent = true, desc = "Move window to top" })
	vim.keymap.set("n", "<C-S-l>", "<C-w>L", { noremap = true, silent = true, desc = "Move window to far right" })
	vim.keymap.set(
		"v",
		"<MiddleMouse>",
		"y",
		{ noremap = true, silent = true, desc = "Yank selection instead of pasting" }
	)
	vim.keymap.set("n", "<C-S>", ":w<CR>", { desc = "Save file" })
	vim.keymap.set("n", "<C-Q>", ":q<CR>", { noremap = true, silent = true, desc = "Quit window" })
	vim.keymap.set("n", "!$", ":%!", { desc = "Pipe entire file through command" })
	vim.keymap.set("v", "g/", "<Esc>/\\%V", { desc = "Search within visual selection" })
	vim.keymap.set("n", "#", "#N", { noremap = true, silent = true, desc = "Search word backward (stay on word)" })
	vim.keymap.set("n", "*", "*N", { noremap = true, silent = true, desc = "Search word forward (stay on word)" })
	vim.keymap.set("n", "T", ":tabnew<CR>", { noremap = true, silent = true, desc = "Create new tab" })
	vim.keymap.set("n", "<C-p>", "gT", { noremap = true, silent = true, desc = "Go to previous tab" })
	vim.keymap.set("n", "<C-n>", "gt", { noremap = true, silent = true, desc = "Go to next tab" })
	vim.keymap.set("n", "<C-PageDown>", "gT", { noremap = true, silent = true, desc = "Go to previous tab" })
	vim.keymap.set("n", "<C-PageUp>", "gt", { noremap = true, silent = true, desc = "Go to next tab" })
	vim.keymap.set("n", "<C-d>", "<C-d>M", { noremap = true, silent = true, desc = "Scroll down half page and center" })
	vim.keymap.set("n", "<C-f>", "<C-f>M", { noremap = true, silent = true, desc = "Scroll down full page and center" })
	vim.keymap.set("n", "<C-b>", "<C-b>M", { noremap = true, silent = true, desc = "Scroll up full page and center" })
	vim.keymap.set("n", "<C-u>", "<C-u>M", { noremap = true, silent = true, desc = "Scroll up half page and center" })
	vim.keymap.set("n", "n", "nzvzz", { noremap = true, silent = true, desc = "Next search result (centered)" })
	vim.keymap.set("n", "N", "Nzvzz", { noremap = true, silent = true, desc = "Previous search result (centered)" })
	vim.keymap.set(
		"n",
		"<PageUp>",
		"<C-b>M",
		{ noremap = true, silent = true, desc = "Scroll up full page and center" }
	)
	vim.keymap.set(
		"n",
		"<PageDown>",
		"<C-f>M",
		{ noremap = true, silent = true, desc = "Scroll down full page and center" }
	)
	vim.keymap.set("n", "H", "<Nop>", { noremap = true, silent = true, desc = "Disabled" })
	vim.keymap.set("n", "L", "<Nop>", { noremap = true, silent = true, desc = "Disabled" })

	-- Remap: Register -------------------------------------------------------------

	vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true, desc = "Delete char without yanking" })

	vim.keymap.set("n", "gp", '"0p', { noremap = true, silent = true, desc = "Paste last yank (register 0)" })
	vim.keymap.set("x", "gp", '"0p', { noremap = true, silent = true, desc = "Paste last yank (register 0)" })

	vim.keymap.set("i", "<C-V>", function()
		vim.api.nvim_input("<C-R>+")
	end, { noremap = true, silent = true, desc = "Paste from default register" })

	vim.keymap.set("c", "<C-V>", function()
		vim.api.nvim_input("<C-R>+")
	end, { noremap = true, silent = true, desc = "Paste from default register" })

	-- Remap: Text-Object action --------------------------------------------------

	vim.keymap.set(
		"n",
		"gL",
		"!!line<CR>",
		{ noremap = true, silent = true, desc = "Replace line with line command output" }
	)
	vim.keymap.set(
		"n",
		"gH",
		"!!header<CR>",
		{ noremap = true, silent = true, desc = "Replace line with header command output" }
	)
	vim.keymap.set("n", "glh", ":.!repl<CR>u", { noremap = true, silent = true, desc = "Send line to REPL" })
	vim.keymap.set("n", "glip", "!iprepl<CR>u", { noremap = true, silent = true, desc = "Send paragraph to REPL" })
	vim.keymap.set(
		"n",
		"gliw",
		'yiw:silent exec "!repl <C-R>0"<CR>u',
		{ noremap = true, silent = true, desc = "Send word to REPL" }
	)
	vim.keymap.set("n", "gll", ":.!repl<CR>u", { noremap = true, silent = true, desc = "Send line to REPL" })
	vim.keymap.set("n", "glr", ":.!repl<CR>u", { noremap = true, silent = true, desc = "Send line to REPL" })
	vim.keymap.set("v", "gl", ":!repl<CR>u", { noremap = true, silent = true, desc = "Send selection to REPL" })
	vim.keymap.set("n", "gbif", "vif:%g/", { desc = "Run global command on function" })
	vim.keymap.set("n", "gbh", "V:g/", { desc = "Run global command on line" })
	vim.keymap.set("n", "gbip", "vip:g/", { desc = "Run global command on paragraph" })
	vim.keymap.set("n", "gbl", "V:g/", { desc = "Run global command on line" })
	vim.keymap.set("n", "gbb", ":%g/", { desc = "Run global command on buffer" })
	vim.keymap.set("v", "gb", ":g/", { desc = "Run global command on selection" })
	vim.keymap.set("n", "gsif", "vif:%s/", { desc = "Substitute in function" })
	vim.keymap.set("n", "gsh", "V:s/", { desc = "Substitute in line" })
	vim.keymap.set("n", "gsip", "vip:s/", { desc = "Substitute in paragraph" })
	vim.keymap.set("n", "gsl", "V:s/", { desc = "Substitute in line" })
	vim.keymap.set("n", "gss", ":%s/", { desc = "Substitute in buffer" })
	vim.keymap.set("v", "gs", ":s/", { desc = "Substitute in selection" })
	vim.keymap.set("n", "goip", "vip:sort<CR>", { noremap = true, silent = true, desc = "Sort paragraph" })
	vim.keymap.set("v", "go", ":sort<CR>", { noremap = true, silent = true, desc = "Sort selection" })

	-- Remap: Toggle ---------------------------------------------------------------

	vim.keymap.set("n", "yoc", ":set cursorcolumn!<CR>", { desc = "Toggle cursor column" })
	vim.keymap.set("n", "yod", optutils.toggle_diagnostics, { desc = "Toggle diagnostics" })
	vim.keymap.set("n", "yof", winutils.fold_all_windows_and_come_back, { desc = "Toggle all folds" })
	vim.keymap.set("n", "yol", ":set list!<CR>", { desc = "Toggle list mode (show whitespace)" })
	vim.keymap.set("n", "yon", ":set number!<CR>", { desc = "Toggle line numbers" })
	vim.keymap.set("n", "yop", ":set paste<CR>", { desc = "Enable paste mode" })
	vim.keymap.set("n", "yor", ":set relativenumber!<CR>", { desc = "Toggle relative line numbers" })
	vim.keymap.set("n", "yose", ":set spelllang=en<CR>", { desc = "Set spell language to English" })
	vim.keymap.set("n", "yosf", ":set spelllang=fr<CR>", { desc = "Set spell language to French" })
	vim.keymap.set("n", "yoss", ":set spell!<CR>", { desc = "Toggle spell check" })
	vim.keymap.set("n", "yow", ":set wrap!<CR>", { desc = "Toggle line wrap" })
	vim.keymap.set("n", "yoh", optutils.toggle_hidden, { desc = "Toggle hidden characters" })
	vim.keymap.set("n", "yoC", optutils.toggle_color_column, { desc = "Toggle color column" })
	vim.keymap.set("n", "yom", optutils.toggle_mouse, { desc = "Toggle mouse support" })

	-- Remap: Fold search ---------------------------------------------------------

	vim.keymap.set("n", "z/", ":SearchOutsideFolds<CR>", { desc = "Search outside folds" })
	vim.keymap.set("n", "zn", function()
		foldutils.search_outside_folds_next(1)
	end, { desc = "Next search outside folds" })
	vim.keymap.set("n", "zN", function()
		foldutils.search_outside_folds_next(-1)
	end, { desc = "Previous search outside folds" })
end

return M
