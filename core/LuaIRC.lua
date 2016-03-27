local socket = require ("socket")
local utils = require ("utils")

local luairc = class ()

function luairc:new (listener, ...)
  self.state = "not connected"
  self.socket = nil
  self.listener = listener or function () end
end

function luairc:connect (host, port)
  local port = port or 6667

  local s = socket.tcp ()
  s:settimeout (30)
  assert (s:connect (host,port))

  -- FIXME: Maybe add SSL ?

  self.socket = s
  self:send ("PASS %s", "randompasswordhereoractuallynothingquestionmark")
  -- FIXME: Authenticate with nickserv here?
  self:send ("NICK Ratbeef")
  local mask = 0
  self:send ("USER Ratbeef %i * :%s",mask, "Ratbeefbot")

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

function luairc:listen ()
  local line, err = self.socket:receive ("*l")

  if line then
    local prefix, cmd, args = utils.parse (line)
    if cmd == "PING" then
      self:send ("PONG :%s", args[1])
    else
      self.listener (prefix, cmd, args)
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

function luairc:start ()
  repeat
    self:listen ()
    socket.sleep (0.1) -- TODO: Find a good value for this
  until (luairc.state == "not connected")
end

function luairc:send (...)
  return self.socket:send (string.format (...) .. "\n")
end

function luairc:raw (...) return self:send (...) end -- Alias for luairc:send

function luairc:join (channel)
  self:send ("JOIN :%s", channel)
end

function luairc:quit (reason)
  self:send ("QUIT :%s", reason)
end

function luairc:privmsg (target, message)
  self:send ("PRIVMSG %s :%s", target, message)
end

function luairc:msg (...) return self:privmsg (...) end -- Alias for luairc:privmsg

-- Optional
function luairc:away (reason)
  self:send ("AWAY :%s", reason)
end

function luairc:close ()
  self.socket:close ()
  self.state = "not connected"
end

return luairc
