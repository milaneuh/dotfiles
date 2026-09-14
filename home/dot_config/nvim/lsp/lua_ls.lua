local function has_own_luarc(client)

  local path = client.workspace_folders[1].name
  local config = vim.fn.stdpath("config")

  if not client.workspace_folders then
    return false
  end

  if vim.uv.fs_realpath(path) == vim.uv.fs_realpath(config) then
    return false
  end

  if vim.uv.fs_stat(path .. "/.luarc.json") then
    return true
  end

  if vim.uv.fs_stat(path .. "/.luarc.jsonc") then
    return true
  end

  return false
end

return {
  on_init = function(client)
    if has_own_luarc(client) then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
}
