if not require("utils.pack").loaded("vim-easy-align") then return end

vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { desc = "Align text (visual)" })
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "Align text (operator)" })
