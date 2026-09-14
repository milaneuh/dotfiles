local M = {}

M.setup = function()
	-- FT, plugin, and indent settings
	vim.o.exrc = true -- Load .nvim.lua if present in the current directory
	vim.o.hidden = false -- Do not switch buffer if there are unsaved modifications
	vim.o.confirm = true -- Prompt to save before switching from modified buffer

	-- Gutentags configuration
	vim.g.gutentags_ctags_executable = 'ctags'

	-- Paths and Files
	vim.o.path = ".,," -- Only index the current file/folder

	-- Appearance
	vim.o.background = "dark"
	vim.env.BAT_THEME = "gruvbox-dark"
	vim.o.wrap = false -- Don't wrap text when the window is too small
	vim.o.showmatch = true -- Show matching braces/parentheses

	-- Alarms
	vim.o.errorbells = false -- Disable bell alarms
	vim.o.visualbell = false -- Disable visual alarm

	-- System Interaction
	vim.opt.clipboard = "unnamedplus"
	if vim.fn.has("mac") == 0 and vim.env.DISPLAY == nil and vim.env.WAYLAND_DISPLAY == nil then
		vim.g.clipboard = "osc52"
	end
	vim.o.encoding = "utf-8" -- Set UTF-8 encoding
	vim.o.compatible = false -- Disable vi compatibility
	vim.o.timeoutlen = 300 -- Set timeout for mappings
	vim.o.ttimeoutlen = 100 -- Set timeout for key codes
	vim.o.updatetime = 500 -- Vital for LSP and Tagbar on Neovim

	-- Files
	vim.o.autoread = true -- Reload buffers changed outside of nvim

	-- Backup
	vim.o.backup = false -- Disable backups
	vim.o.swapfile = false -- Disable swap file
	vim.o.writebackup = false -- Disable write backups

	-- Navigation
	vim.o.mouse = "a" -- Enable mouse selection
	vim.o.number = true -- Display line numbers
	vim.o.scrolloff = 8 -- Enable scrolling when reaching the bottom
	vim.o.grepprg = "rg --vimgrep" -- Use ripgrep with ignore file

	-- Diff
	vim.opt.diffopt:remove("linematch:40") -- Fix Fugitive alignment problem
	vim.opt.diffopt:append({ "algorithm:histogram", "linematch:200" }) -- Fix Fugitive alignment problem

	-- Search
	vim.o.ignorecase = true -- Ignore case in search
	vim.o.smartcase = true -- Use smart case search
	vim.o.hlsearch = true -- Highlight search results
	vim.o.incsearch = true -- Show results while searching

	-- Text Formatting
	vim.o.tabstop = 2 -- Set tab width to 2 spaces
	vim.o.softtabstop = 2 -- Set soft tab width to 2 spaces
	vim.o.shiftwidth = 2 -- Set indentation width to 2 spaces
	vim.o.textwidth = 0 -- Don't wrap lines automatically
	vim.o.expandtab = true -- Convert tabs to spaces
	vim.o.listchars = "nbsp:!" -- Show non-breaking spaces

	-- Spelling
	vim.o.spelllang = "en" -- Set English as the spellcheck language

	-- Autocompletion
	vim.o.wildmenu = true -- Enable completion in command mode
	vim.o.wildignorecase = true -- Ignore case in wildmenu

	-- Tabs
	vim.o.showtabline = 1
	vim.o.tabline = "%!v:lua.require('utils.tabs').tabline()"

	-- Diagnostics
	DIAGNOSTICS_ACTIVE = true
	vim.diagnostic.config({
		virtual_lines = true,
	})

end

return M
