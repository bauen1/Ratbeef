local core = require ("core")

function raw (prefix, channel, ...)
  core.irc:send (table.concat ({...}, " "))
end

core:addCommand ("raw", raw, true)
