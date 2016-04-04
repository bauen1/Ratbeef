local socket = require ("socket")
local utils = require ("utils")

local irc = class ()

function irc:new (listener, ...)
  self.state = "not connected"
  self.socket = nil
  self.listener = listener or function () end
end

function irc:connect (host, port, nickname, username, ssl)
  local port = port or 6667

  local s = socket.tcp ()
  s:settimeout (30)
  assert (s:connect (host,port))

  if ssl then
    -- Do SSL Stuff HERE!
  end

  self.socket = s
  --self:send ("PASS %s", "randompasswordhereoractuallynothingquestionmark")
  self:send ("NICK %s", nickname)
  local mask = 0
  self:send ("USER %s %i * :realname",username,mask)

  while true do
    local line = self:listen ()
    if not line then
      socket.sleep (0.1)
    else
      local s,e = string.find (line, ":End of /MOTD command%.") -- Shameless copied from Numatron
      if s and e then
        break; -- We are initialized
      end
    end
  end
end

function irc:listen ()
  local line, err = self.socket:receive ("*l")

  if line then
    print ("<< " .. line)
    local prefix, cmd, args, suffix = utils.parse (line)
    if cmd == "PING" then
      self:send (line:gsub ("PING", "PONG"))
    else
      local ret = table.pack (xpcall (self.listener, function (e)
        return debug.traceback (e)
      end, prefix, cmd, args, suffix))
    end
    return line
  else
    if err == "timeout" then
      return nil
    elseif err == "closed" then
      self:close ()
    end
  end
end

function irc:start ()
  repeat
    self:listen ()
    socket.sleep (0.01) -- TODO: Make this multithreaded
  until (irc.state == "not connected")
end

function irc:send (str, ...)
  local s = string.format (tostring (str), ...)
  print (">> " .. s)
  pcall (assert, str:len (str) <= 512, "Warning, sended message exceeds the limit of 512 chars!")
  socket.sleep (0.1) -- So we dont totaly spam and waste cpu
  return self.socket:send (s .. "\n")
end

function irc:raw (...) return self:send (...) end -- Alias for irc:send

function irc:join (channel)
  self:send ("JOIN :%s", channel)
end

function irc:quit (reason)
  self:send ("QUIT :%s", reason or "quit")
end

function irc:privmsg (target, message)
  self:send ("PRIVMSG %s :%s", target, message)
end

function irc:action (target, message)
  self:send ("PRIVMSG %s :\1ACTION %s\1", target, message)
end

function irc:say (channel, message) return self:privmsg (channel, message) end

function irc:msg (...) return self:privmsg (...) end -- Alias for irc:privmsg

-- Optional
function irc:away (reason)
  self:send ("AWAY :%s", reason)
end

function irc:close ()
  self.socket:close ()
  self.state = "not connected"
end

return irc
