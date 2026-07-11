if not require("utils.pack").loaded("vim-dispatch") then return end

vim.keymap.set("n", "<leader>m", ":Make<cr>", { desc = "Run Make asynchronously" })
