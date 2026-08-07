if not require("utils.pack").loaded("fzf-lua") then return end

local config = require("utils.plugin.fzf.config")
local keybindings = require("utils.plugin.fzf.keybindings")

config.setup()
keybindings.setup()
