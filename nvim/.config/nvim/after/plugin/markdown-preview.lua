if not require("utils.pack").loaded("markdown-preview.nvim") then return end

vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_auto_close = 0

vim.cmd([[
function! g:MkdpOpenInNewWindow(url) abort
	call jobstart(['google-chrome', '--app=' . a:url], { 'detach': v:true })
endfunction
]])
vim.g.mkdp_browserfunc = "MkdpOpenInNewWindow"

vim.keymap.set("n", "<leader>fm", ":MarkdownPreview<CR>", { desc = "Markdown preview" })
