local core = require ("core")

local function echo (prefix, channel, ...)
  core:respond (channel, table.concat ({...}," " ))
  core:raw (string.format ("PRIVMSG %s :%s ", channel, table.concat ({...},"  ")))
end

core:addCommand ("echo", echo)
