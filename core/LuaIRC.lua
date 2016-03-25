local socket = require ("socket")
local utils = require ("utils")

local luairc = class ()

function luairc:new (...)
  self.state = "not connected"
  self.socket = nil
end

function luairc:send (...)
  return self.socket:send (...)
end

function luairc:connect (host, port)
  local port = port or 6667

  local s = socket.tcp ()
  s:settimeout (30)
  assert (s:connect (host,port))

  self.socket = s
  self:send ("")

  -- Do IRC Stuff here
end



return luairc
