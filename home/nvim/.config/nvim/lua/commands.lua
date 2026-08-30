local M = {}

M.setup = function()
	local tabutils = require("utils.tabs")

	-- Write file as sudo
	vim.api.nvim_create_user_command("W", [[execute ':silent w !sudo tee % > /dev/null' | edit!]], {})

	-- Reload the current Neovim config and echo a message
	vim.api.nvim_create_user_command("Reload", function()
		vim.cmd("source " .. vim.fn.expand("$MYVIMRC"))
		vim.cmd('echo "Configuration Reload!"')
	end, {})

	vim.api.nvim_create_user_command("TabRename", function(opts)
		tabutils.tab_rename(opts.args)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("SearchOutsideFolds", function(opts)
		local pattern = opts.args
		if pattern == "" then
			pattern = vim.fn.input("Search outside folds: ")
		end
		if pattern ~= "" then
			local current_pos = vim.fn.getpos(".")
			local total_lines = vim.fn.line("$")
			local found = false

			for i = current_pos[2], total_lines do
				if vim.fn.foldclosed(i) == -1 then
					local line_content = vim.fn.getline(i)
					local match_col = vim.fn.match(line_content, pattern)
					if match_col >= 0 then
						vim.fn.cursor(i, match_col + 1)
						vim.fn.setreg("/", pattern)
						vim.cmd("set hlsearch")
						found = true
						break
					end
				end
			end

			if not found then
				for i = 1, current_pos[2] - 1 do
					if vim.fn.foldclosed(i) == -1 then
						local line_content = vim.fn.getline(i)
						local match_col = vim.fn.match(line_content, pattern)
						if match_col >= 0 then
							vim.fn.cursor(i, match_col + 1)
							vim.fn.setreg("/", pattern)
							vim.cmd("set hlsearch")
							found = true
							break
						end
					end
				end
			end

			if not found then
				print("Pattern not found outside folds: " .. pattern)
			end
		end
	end, { nargs = "?" })

end

return M
