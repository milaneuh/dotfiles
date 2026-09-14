local M = {}

M.setup = function()
	local gh = function(x) return "https://github.com/" .. x end

	local override_bundled_mermaid = function(plugin_path)
		local source = vim.fs.joinpath(vim.fn.stdpath("data"), "mermaid.min.js")
		local target = vim.fs.joinpath(plugin_path, "app", "_static", "mermaid.min.js")

		if vim.uv.fs_stat(source) == nil then
			vim.notify("mermaid.min.js missing, run home-manager switch", vim.log.levels.ERROR)
			return
		end

		vim.fn.delete(target)
		vim.uv.fs_symlink(source, target)
	end

	-- Netrw (replaced by oil.nvim), couldn't be put in after folder
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then return end

			if name == "nvim-treesitter" then
				if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
				vim.cmd("TSUpdate")
			elseif name == "vim-go" then
				if not ev.data.active then vim.cmd.packadd("vim-go") end
				vim.cmd("GoUpdateBinaries")
			elseif name == "LuaSnip" then
				vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path })
			elseif name == "markdown-preview.nvim" then
				vim.fn["mkdp#util#install"]()
				override_bundled_mermaid(ev.data.path)
			end
		end,
	})

	vim.pack.add({
		-- AI
		gh("coder/claudecode.nvim"),

		-- AST
		{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
		{ src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },

		-- Completion
		gh("hrsh7th/cmp-buffer"),
		gh("hrsh7th/cmp-cmdline"),
		gh("hrsh7th/cmp-nvim-lsp"),
		gh("hrsh7th/cmp-path"),
		gh("hrsh7th/cmp-emoji"),
		gh("hrsh7th/nvim-cmp"),
		gh("saadparwaiz1/cmp_luasnip"),

		-- Git
		gh("tpope/vim-fugitive"),
		gh("airblade/vim-gitgutter"),

		-- Diff
		gh("AndrewRadev/linediff.vim"),

		-- LSP, Linter, Formatter and DAP
		gh("fatih/vim-go"),
		gh("mfussenegger/nvim-lint"),
		gh("neovim/nvim-lspconfig"),
		gh("stevearc/conform.nvim"),

		-- Navigation (Files, Windows, Buffers, Tags, ...)
		gh("ibhagwan/fzf-lua"),
		gh("stevearc/oil.nvim"),
		gh("ludovicchabant/vim-gutentags"),
		gh("preservim/tagbar"),
		gh("szw/vim-maximizer"),
		gh("mrjones2014/smart-splits.nvim"),
		gh("folke/which-key.nvim"),
		gh("jghauser/follow-md-links.nvim"),

		-- Snippet
		{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.0") },
		gh("honza/vim-snippets"),

		-- Theme and GUI/TUI
		gh("ellisonleao/gruvbox.nvim"),
		gh("hakonharnes/img-clip.nvim"),
		gh("nvim-tree/nvim-web-devicons"),
    gh("iamcco/markdown-preview.nvim"),

		-- Text Editing
		gh("dhruvasagar/vim-table-mode"),
		gh("kylechui/nvim-surround"),
		gh("junegunn/vim-easy-align"),
		gh("MagicDuck/grug-far.nvim"),
		gh("windwp/nvim-autopairs"),
		gh("tpope/vim-rsi"),

		-- System
		gh("tpope/vim-dispatch"),
		gh("tpope/vim-eunuch"),
	})
end

return M
