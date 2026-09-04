if not require("utils.pack").loaded("grug-far.nvim") then return end

local bufutils = require("utils.buffers")

require("grug-far").setup({})

local search
if vim.api.nvim_get_mode().mode == "v" then
	search = bufutils.get_visual_selection()
else
	search = ""
end

vim.keymap.set({ "n", "x" }, "<leader>S", function()
	require("grug-far").open({ prefills = { search = search } })
end, { desc = "grug-far: Search within range" })
