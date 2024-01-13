local count = require 'visimp.pak.count'
local init = require 'visimp.pak.init'
local window = require 'visimp.pak.window'
local M = {}

--- Lists all manged packages
function M.list()
  window.set_title 'Package listing'
  local keys = vim.tbl_keys(init.packages)
  table.sort(keys)
  local pkgs = {}
  for _, k in ipairs(keys) do
    pkgs[k] = init.sym_tbl[k] or ' '
  end

  count.set_status ''
  count.updates(pkgs)
  window.lock()
end

--- Registers a new package
-- @param args Either a string or a list or a table which represents a valid
--             object data type
function M.register(args)
  if type(args) == 'string' then
    args = { args }
  end
  local name, src
  if args.as then
    name = args.as
  elseif args.url then
    name = args.url:gsub('%.git$', ''):match '/([%w-_.]+)$'
    src = args.url
  else
    name = args[1]:match '^[%w-]+/([%w-_.]+)$'
    src = args[1]
  end
  if not name then
    error('Invalid package source: ' .. src)
  elseif init.packages[name] then
    return
  end

  local dir = init.pakdir .. (args.opt and 'opt/' or 'start/') .. name

  init.packages[name] = {
    name = name,
    branch = args.branch,
    dir = dir,
    exists = vim.fn.isdirectory(dir) ~= 0,
    pin = args.pin,
    url = args.url or ('https://github.com/' .. args[1] .. '.git'),
  }
end

--- Returns true if any packages are not installed (missing)
-- @returns True if packages are missing
function M.any_missing()
  for _, pkg in pairs(init.packages) do
    if not pkg.exists then
      return true
    end
  end
  return false
end

return M
