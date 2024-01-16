local L = require('visimp.layer').new_layer 'java'
local layers = require 'visimp.loader'

L.default_config = {
  -- The lsp server to use. Defaults to eclipse's jdtls downloaded via standard
  -- POSIX tools, but users can also provide their own installation.
  lsp = nil,
  -- Optional configuration to be provided for the chosen language server
  lspconfig = nil,
}

function L.dependencies()
  local deps = { 'treesitter' }
  if L.config.lsp ~= false then
    table.insert(deps, 'lsp')
  end
  return deps
end

function L.preload()
  -- Configure treesitter
  layers.get('treesitter').langs { 'java' }

  -- Enable the language server
  if L.config.lsp ~= false then
    local install = L.config.lsp == nil
    local server = L.config.lsp or 'jdtls'
    local settings = L.config.lspconfig
    layers.get('lsp').use_server('java', install, server, settings)
  end
end

return L
