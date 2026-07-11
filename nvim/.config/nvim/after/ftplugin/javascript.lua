local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
vim.fn.setreg("l", 'yoconsole.log("' .. esc .. 'pa:", ' .. esc .. "pa)" .. esc .. "_")
