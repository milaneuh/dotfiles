local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

vim.cmd("compiler go")
vim.fn.setreg("l", 'yofmt.Println("' .. esc .. 'pa:" + ' .. esc .. "pa)" .. esc .. "_")
