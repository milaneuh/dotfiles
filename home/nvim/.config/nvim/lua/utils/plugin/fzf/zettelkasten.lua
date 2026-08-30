local M = {}

local utils = require("utils.plugin.fzf.utils")

function M.k_find(cwd)
	local opts = {}
	opts.cwd = cwd
	opts.preview = "bat -p --theme=${BAT_THEME} --color=always {1}.md "
	opts.fzf_opts = {
		["--with-nth"] = "3..",
		["--ignore-case"] = "",
		["--multi"] = "",
	}

	local visual_query = utils.get_visual_query()
	opts.query = visual_query

	local is_visual_mode = visual_query ~= nil

	if is_visual_mode then
		opts.actions = {
			["ctrl-t"] = function(selected)
				for i = 1, #selected do
					local filename = string.gsub(selected[i], " .*", "")
					local link = "[" .. visual_query .. "](" .. filename .. ".md)"
					vim.cmd("normal! c" .. link)
				end
			end,
			default = function(selected)
				for i = 1, #selected do
					local filename = string.gsub(selected[i], " .*", "")
					local link = "[" .. visual_query .. "](" .. filename .. ".md)"
					vim.cmd("normal! c" .. link)
				end
			end,
		}
	else
		opts.actions = {
			["ctrl-t"] = function(selected)
				for i = 1, #selected do
					local filename = string.gsub(selected[i], " .*", "")
					vim.cmd("tabnew " .. cwd .. "/" .. filename .. ".md")
				end
			end,
			default = function(selected)
				for i = 1, #selected do
					local filename = string.gsub(selected[i], " .*", "")
					vim.cmd("e " .. cwd .. "/" .. filename .. ".md")
				end
			end,
		}
	end

	if cwd == os.getenv("zettelkasten") then
		opts.prompt = "Zet> "
	else
		opts.prompt = "ZetCompany> "
	end

	require("fzf-lua").fzf_exec("kl list --dir " .. cwd, opts)
end

function M.k_new(cwd)
	if not cwd then
		print("Error: No directory specified")
		return
	end

	local timestamp = os.date("%Y%m%d%H%M%S")
	local filepath = cwd .. "/" .. timestamp .. ".md"
	local file = io.open(filepath, "w")

	if file then
		file:write("# " .. "\n")
		file:close()
		vim.cmd("e " .. filepath)
	else
		print("Error: Could not create file " .. filepath)
	end
end

return M
