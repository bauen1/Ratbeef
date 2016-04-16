local utils = require ("utils")
local socket = require "socket"
local irc = require ("irc")
local parser = require ("parser")

local core = class ()

function core:new ()
  --self.parser = parser ()
  self.irc = irc (function (...)return self:listener (...) end)
  self.modules = {}
  self.commands = {}
  self.settings = require ("settings")

  -- TODO: Check settings for errors (nil values)
  assert (self.settings.server, "No server set in settings.lua")
  assert (self.settings.nickname, "No Nickname set in settings.lua")
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

function core:listener (prefix, cmd, args, suffix)
  if cmd == "PRIVMSG" then
    self:on_privmsg (prefix, args, suffix)
  elseif cmd == "INVITE" then
    -- This is not a whore bot
  elseif cmd == "KICK" then
    local channel = args[1]
    local nickname = args[2]
    local reason = args[3]

    if nickname == self.settings.nickname then -- FIXME, Nickname can change!
      self.irc:join ("#" .. channel)
      self.irc:privmsg ("#" .. channel, "I'm alive ! I'm alive!")
    end
  else
    -- Something might have to be done here
  end
end

function core:on_privmsg (prefix, args, suffix)
  local channel = table.remove (args, 1)

  local prefixLen = string.len (self.settings.prefix)

  if string.sub (suffix, 1, prefixLen) == self.settings.prefix then
    suffix = string.sub (suffix, prefixLen+1, -1)
    local tokens = utils.split (suffix)
    local cmd_name = tokens[1];
    local command = self.commands [table.remove (tokens, 1)]
    if command then
      if command.adminonly then
        local nick = utils.getNick (prefix)

        local authed = false

        for k,v in pairs (self.settings.admins) do
          if v == nick then authed = true break end
        end

        if authed then
          if cmd_name == "die" then
            command.func (prefix, channel, table.concat (tokens, " "))
          else
            self:respond (channel, "Disabled for security reasons.")
          end
          --command.func (prefix, channel, table.concat (tokens, " "))
        else
          self:respond (channel, "Nope.")
        end
      else
        command.func (prefix, channel, table.concat (tokens, " "))
      end
    else
      self:respond (channel, "Not found")
    end
  end
end

--[[
function core:invoke_cmd (cmdname, prefix, cmd_arg, ...)
  local command = self.commands [cmdname]

  if not command then
    return false, "Command not found"
  end

  if command.adminonly then


  else
    command.func (prefix, channel)
  end
end
]]

function core:disconnect (reason)
  self.irc:quit (reason)
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
  for _, v in pairs (modules) do
    print (string.format ("Module unloaded %s", tostring (v)))
    package.loaded[tostring (modules)] = nil
  end

  self.modules = {}
  self.commands = {}
  print ("Modules unloaded")
end

function core:loadmodule (name)
  local ret = table.pack (pcall (require, name))
  if ret[1] then
    return ret[2] or nil
  else
    print (string.format ("Failed to load module '%s' an error occoured.\n%s", name, ret[2]))
  end
end

function core:start ()
  -- Listen for incomming messages
  repeat
    self.irc:listen ()
    local inline = io.read ()
    if inline then
      print ("> " .. inline)
      local f,r = load (inline, "=(Console)","t",_G)
      if f then
        local ret = table.pack (pcall (f, self))

        if #ret == 1 then
          table.insert (ret, "nil")
        end

        if ret[1] then
          print ("> " .. table.concat (ret, " ", 2))
        else
          print ("> " .. tostring (ret[2] or "nil"))
        end
      else
        print ("> " .. tostring (r or "nil"))
      end
    end
    socket.sleep (0.01) -- TODO: Make this multithreaded
  until (self.irc.state == "not connected")
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
  msg = utils.sanitize (msg or "nil passed as message to respond!")
  self.irc:privmsg (channel, msg)
end

function core:action (channel, msg)
  self.irc:action (channel, msg or "nil")
end

function core:raw (...)
  return self.irc:raw (...)
end

function core:send (...) return self:raw (...) end

return core
