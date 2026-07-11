local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
vim.fn.setreg("l", 'yoprint("' .. esc .. 'pa:" .. ' .. esc .. "pa)" .. esc .. "_")
