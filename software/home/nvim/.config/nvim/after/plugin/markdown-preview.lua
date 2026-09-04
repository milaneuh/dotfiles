if not require("utils.pack").loaded("markdown-preview.nvim") then return end

vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_auto_close = 0

vim.cmd([[
function! g:MkdpOpenInNewWindow(url) abort
	call jobstart(['google-chrome',
		\ '--user-data-dir=' . expand('~/.cache/mkdp-chrome'),
		\ '--no-first-run',
		\ '--app=' . a:url], { 'detach': v:true })
endfunction
]])
vim.g.mkdp_browserfunc = "MkdpOpenInNewWindow"

-- Vérifie le disque chaque seconde pour recharger les buffers modifiés
-- de l'extérieur, même quand nvim n'a pas le focus (autoread seul ne
-- vérifie que sur FocusGained/BufEnter)
local checktime_timer = vim.uv.new_timer()
checktime_timer:start(1000, 1000, vim.schedule_wrap(function()
	if vim.fn.mode():match("[^c]") and vim.fn.getcmdwintype() == "" then
		vim.cmd("silent! checktime")
	end
end))

-- Pousse le refresh vers le navigateur quand un buffer est rechargé :
-- le plugin ne le fait que sur les événements curseur, donc jamais
-- quand nvim est idle en arrière-plan
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*.md",
	callback = function(args)
		vim.api.nvim_buf_call(args.buf, function()
			vim.fn["mkdp#rpc#preview_refresh"]()
		end)
	end,
})

vim.keymap.set("n", "<leader>fm", ":MarkdownPreview<CR>", { desc = "Markdown preview" })
