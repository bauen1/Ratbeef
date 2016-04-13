local core = require "core"
local utils = require "utils"
local socket = require "socket"

core:addCommand ("info", function (prefix, channel, suffix)
  core:respond (channel, "Info command called, dunno what to add here - bauen1")
end)

core:addCommand ("source", function (prefix, channel, suffix)
  core:respond (channel, "I'm available at https://github.com/bauen1/Ratbeef")
end)

core:addCommand ("list", function (prefix, channel, suffix)
  local cmd_list = {}

  for k,v in pairs (core.commands) do
    table.insert (cmd_list, k)
  end
  core:respond (channel, "Command List: " .. table.concat (cmd_list, ", "))
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
