if not require("utils.pack").loaded("nvim-cmp") then return end

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-Y>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		["<-S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	}),

	enabled = function()
		local context = require("cmp.config.context")
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
})

cmp.setup.filetype("markdown", {
	sources = cmp.config.sources({
		{ name = "emoji" },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline({}),

	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	-- It's rewritting the default vim behavior. Why have they done that ?
	--   <C-p> is used to search for the previous item
	--   <up> is used to search for the previous item that start with the current command
	mapping = cmp.mapping.preset.cmdline({
		["<C-n>"] = {
			c = false,
		},
		["<C-p>"] = {
			c = false,
		},
	}),
	sources = cmp.config.sources({
		{ name = "path" },
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "args", "grep" }, -- Too long to load
			},
		},
	}),
})
