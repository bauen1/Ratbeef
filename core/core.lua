local utils = require ("utils")
local luairc = require ("LuaIRC")

local core = class ()

function core:new ()
  self.luairc = luairc ()
  self.modules = {}
  self.commands = {}
end

function core:connect (host, port)
  self.luairc:connect (host, port)
end

function core:disconnect ()
  self.luairc:quit ()
  self.luairc:close ()
end

function core:loadmodules ()
  package.path = package.path .. ";./modules/?/?.lua"
  local modules = utils.list ("modules")

  for _, name in pairs (modules) do
    package.path = package.path .. ";./modules/"..name.."/?.lua"
    table.insert (self.modules, self:loadmodule (name))
  end

  print (string.format ("%i Modules loaded", #self.modules))
end

function core:loadmodule (name) -- TODO: pcall everything
  local module = require (name)

  return module
end

function core:start ()
  -- Start listening for messages
  self.luairc:listen ()
end

function core:addCommand (name, func, adminonly)
  print (string.format ("Registered command '%s'", name))
  assert (not self.commands [name], string.format ("Command %s already registered",name))
end

function core:respond (msg)
  self.luairc:privmsg ("#V", msg or "nil passed as message to respond!")
  print (msg)
end

return core
