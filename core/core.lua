local utils = require ("utils")
local luairc = require ("LuaIRC")

local core = class ()

function core:new ()
  self.luairc = luairc ()
end

function core:connect (host, port)
  self.luairc:connect (host, port)
end

function core:addCommand ()
end

function core:respond (msg)
  print (msg)
end

return core
