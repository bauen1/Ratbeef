local utils = require ("utils")
local irc = require ("irc")
local parser = require ("parser")

local core = class ()

function core:new ()
  --self.parser = parser ()
  self.irc = irc (function (...) print (...) return self:listener (...) end)
  self.modules = {}
  self.commands = {}
  self.settings = require ("settings")

  -- TODO: Check settings for errors (nil values)
end

function core:connect ()
  self.irc:connect (self.settings.server, self.settings.port,self.settings.nickname,self.settings.username, self.settings.ssl)
  for i, v in ipairs (self.settings.connect_commands) do
    self:send (tostring(v))
  end
  self.irc:send ("NICK %s", self.settings.nickname)
  for i, v in ipairs (self.settings.channels) do
    self.irc:join (tostring (v))
  end
end

function core:listener (prefix, cmd, args, ...)
  if cmd == "PRIVMSG" then
    self:on_privmsg (prefix, args[1], table.unpack (args, 2))
  elseif cmd == "INVITE" then
    if args[1] and args[2] then
      local me = args[1]
      local channel = args[2]
      local caller = prefix

      self.irc:join (channel)
      self.irc:privmsg (channel, "Here I am, '"..prefix.."' called me!")
    end
  else
    -- Something might have to be done here
  end
end

function core:on_privmsg (prefix, channel, ...)
  local args = table.pack (...)

  local pre_cmd = args[1] or "nil"
  local command = nil
  local channel = "#" .. channel

  if pre_cmd == self.settings.prefix then
    command = args[2] or "nil"
  elseif pre_cmd:find ("^"..self.settings.prefix) then
    local _, e = pre_cmd:sub (pre_cmd:find ("^"..self.settings.prefix))
    command = pre_cmd:sub (e+1)
  end

  local command = self.commands [command]
  if command then
    if command.adminonly then
      --[[if prefix == "bauen1" then
        command.func (table.unpack (args, 2))
      else]]
        self:respond ("Nope.")
      --end
    else
      command.func (prefix, channel, ...)
    end
  end
end

function core:disconnect ()
  self.irc:quit ()
  self.irc:close ()
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
  self.irc:start ()
end

function core:addCommand (name, func, adminonly)
  print (string.format ("Registered command '%s'", name))
  assert (not self.commands [name], string.format ("Command %s already registered",name))
  pcall (assert, name:find ("(%s)"), "Command '" .. name .. "' contains a space and is therefor inaccesible")
  self.commands [name] = {
    func=func,
    adminonly=adminonly
  }
end

function core:respond (channel, msg)
  msg = utils.sanitize (msg)
  self.irc:privmsg (channel, msg or "nil passed as message to respond!")
end

function core:raw (...)
  return self.irc:raw (...)
end

function core:send (...) return self:raw (...) end

return core
