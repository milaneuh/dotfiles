local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
vim.fn.setreg("l", "yoIO.inspect(" .. esc .. "pa, " .. esc .. 'alabel: "' .. esc .. 'pa")' .. esc .. "_")
vim.bo.makeprg = "iex -S mix"
