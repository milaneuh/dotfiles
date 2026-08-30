if not require("utils.pack").loaded("diagram.nvim") then return end

require("diagram").setup({
  integrations = {
    require("diagram.integrations.markdown"),
    require("diagram.integrations.neorg"),
  },
  events = {
    render_buffer = { "BufWinEnter", "BufWritePost" },
    clear_buffer = { "BufLeave" },
  },
  renderer_options = {
    mermaid = {
      background = "transparent",
      cli_args = { "-p", vim.fn.expand("~/.config/puppeteer-config.json") },
    },
  },
})
