if not require("utils.pack").loaded("opencode.nvim") then return end

local port = nil
local tmux = vim.fn.getenv("TMUX")
if tmux ~= vim.NIL and tmux ~= "" then
	local raw = vim.fn.system("tmux display-message -p '#{session_id}' 2>/dev/null")
	local session_num = tonumber(raw:match("%$?(%d+)"))
	if session_num then
		port = 4100 + session_num
	end
end

vim.g.opencode_opts = {
	server = {
		port = port,
	},
	events = {
		reload = true,
	},
}

vim.o.autoread = true

vim.keymap.set({ "n", "x" }, "<leader>ii", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "IA: Ask opencode" })

vim.keymap.set({ "n", "x" }, "<leader>is", function()
	require("opencode").select()
end, { desc = "IA: Select action" })

vim.api.nvim_create_autocmd("User", {
	pattern = "OpencodeEvent:*",
	callback = function(args)
		local event = args.data.event
		if event.type == "session.idle" then
			vim.notify("OpenCode finished responding", vim.log.levels.INFO)
		end
	end,
})
