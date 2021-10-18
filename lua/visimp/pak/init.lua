local count = require('visimp.pak.count')
local window = require('visimp.pak.window')

local M = {
  update_count = 0,
  pakdir = vim.fn.stdpath("data") .. "/site/pack/paks/",
  logfile = vim.fn.stdpath("cache") .. "/pak.log",
  sym_tbl = {install = '+', update = '*', remove = '-'},
  packages = {}
}

--- Fills the dialog with initial data on registered packages
function M.fill()
  M.update_count = 0
  local keys = vim.tbl_keys(M.packages)
  table.sort(keys)
  local pkgs = {}
  for _, k in ipairs(keys) do
    pkgs[k] = '-'
  end
  count.updates(pkgs)
end

--- Updates the given package entry with the proper symbol
-- @param name The key of the package entry to update
-- @param symbol The char to assign in the entry
function M.update(name, symbol)
  count.update(name, symbol)
  M.update_count = M.update_count + 1
  if M.update_count == vim.tbl_count(M.packages) then
    window.lock() -- customizable
  end
end

return M
