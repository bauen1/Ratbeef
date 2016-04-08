local core = require "core"
local utils = require "utils"
local socket = require "socket"

local function hate (prefix, channel, suffix)
end

local function like (prefix, channel, suffix)
end

local function love (prefix, channel, suffix)
end

core:addCommand ("hate", hate, true)
core:addCommand ("like", like, true)
core:addCommand ("love", love, true)

core:addCommand ("info", function (prefix, channel, suffix)
  core:respond (channel, "Info command called, dunno what to add here - bauen1")
end)

--[[
core:addCommand ("repeat", function (prefix, channel, suffix)
  local nick = utils.getNick (prefix)
  local tokens = utils.split (suffix)

  local n = tokens[1]
  local cmd = table.concat (tokens, "", 2)

  if (not n) or (not cmd) then
    core:respond ("Usage: repeat <number of time> <command>")
    return
  end

  n = tonumber (n)

  for i=0, n do
    core:on_privmsg (prefix, {}, cmd)
    socket.sleep (0.05)
  end

end, true)
]]--
