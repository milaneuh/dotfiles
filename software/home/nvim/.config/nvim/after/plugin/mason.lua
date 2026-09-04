local loaded = require("utils.pack").loaded
if not loaded("mason.nvim") then return end

require("mason").setup()

if not loaded("mason-lspconfig.nvim") then return end

require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "cssls",
    "expert",
    "html",
    "jinja_lsp",
    "jsonls",
    "lua_ls",
    "marksman",
    "pyright",
    "ts_ls",
    "gopls",
    "lemminx",
  },
})
