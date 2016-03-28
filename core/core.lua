local utils = require ("utils")
local luairc = require ("LuaIRC")
local parser = require ("parser")

local core = class ()

function core:new ()
  self.parser = parser ()
  self.luairc = luairc (function (...) return self:listener (...) end)
  self.modules = {}
  self.commands = {}
end

function core:connect (host, port)
  self.luairc:connect (host, port)
  self.luairc:join ("#V") -- Best (and dangeroused) channel on irc.esper.net!
end

function core:listener (prefix, cmd, args, ...)
  if cmd == "PRIVMSG" then
    local command = self.commands [args[1]]
    if command then
      if command.adminonly then
        if prefix == "bauen1" then
          command.func (table.unpack (args, 2))
        else
          self:respond ("Nope.")
        end
      else
        command.func (table.unpack (args, 2))
      end
    end
  else
    -- Something might have to be done here
  end

  return print (prefix, cmd, args, ...)
end

function core:disconnect ()
  self.luairc:quit ()
  self.luairc:close ()
end

function core:loadmodules ()
  self.oldpath = package.path
  package.path = package.path .. ";./modules/?/?.lua"
  local modules = utils.list ("modules")

  for _, name in pairs (modules) do
    package.path = package.path .. ";./modules/"..name.."/?.lua"
    table.insert (self.modules, self:loadmodule (name))
  end

  print (string.format ("%i Modules loaded", #self.modules))
end

function core:unloadmodules ()
  package.path = self.oldpath or package.path
  self.modules = {}
  self.commands = {}
  print ("Modules unloaded")
end

function core:loadmodule (name) -- TODO: pcall everything
  local module = require (name)

  return module
end

function core:start ()
  -- Start listening for messages
  self.luairc:start ()
end

function core:addCommand (name, func, adminonly)
  print (string.format ("Registered command '%s'", name))
  assert (not self.commands [name], string.format ("Command %s already registered",name))
  self.commands [name] = {
    func=func,
    adminonly=adminonly}
end

function core:respond (msg)
  msg = utils.sanitize (msg)
  self.luairc:privmsg ("#V", msg or "nil passed as message to respond!")
  print ("respond: ", msg)
end

function core:raw (...)
  return self.luairc:raw (...)
end

return core
