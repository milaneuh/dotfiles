local M = {}

--- @param name string Plugin name (last segment of its source URL)
--- @return boolean
function M.loaded(name)
  local ok, res = pcall(vim.pack.get, { name })
  return ok and #res > 0 and res[1].active
end

return M
