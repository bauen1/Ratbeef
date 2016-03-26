local socket = require ("socket")
local utils = require ("utils")

local luairc = class ()

function luairc:new (...)
  self.state = "not connected"
  self.socket = nil
end

function luairc:send (s, ...)
  return self.socket:send (string.format (...))
end

function luairc:raw (...) return self:send (...) end -- Alias for luairc:send

function luairc:connect (host, port)
  local port = port or 6667

  local s = socket.tcp ()
  s:settimeout (30)
  assert (s:connect (host,port))

  self.socket = s
  self:send ("")

  -- Do IRC Stuff here
end

function luairc:join (channel)
  self.s:send ("JOIN :")
end

function luairc:quit (reason)
  self.s:send ("QUIT :%s", reason)
end

function luairc:privmsg (target, message)
  self.s:send ("PRIVMSG %s :%s", target, message)
end

function luairc:msg (...) return self:privmsg (...) end -- Alias for luairc:privmsg

-- Optional
function luairc:away (reason)
  self.s:send ("AWAY :%s", reason)
end

function luairc:close ()
  self.s:close ()
  self.state = "not connected"
end

return luairc
