if not require("utils.pack").loaded("img-clip.nvim") then return end

local zettelkasten_utils = require("utils.plugin.img-clip")

require("img-clip").setup({
	filetypes = {
		markdown = {
			dir_path = function()
				local is_zettelkasten, zettelkasten_dir = zettelkasten_utils.get_zettelkasten_info()

				if is_zettelkasten then
					return zettelkasten_dir
				else
					return "."
				end
			end,
			file_name = function()
				local is_zettelkasten = zettelkasten_utils.get_zettelkasten_info()

				if is_zettelkasten then
					local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local image_count = 0
					for _, line in ipairs(buf_lines) do
						for _ in string.gmatch(line, "!%[.-%]%(.-%)") do
							image_count = image_count + 1
						end
					end

					local buf_name = vim.fn.expand("%:t:r")
					local counter = image_count
					return buf_name .. "_" .. counter .. ".png"
				else
					return os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
				end
			end,
		},
	},
})
