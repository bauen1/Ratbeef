local core = require ("core")

function raw (prefix, channel, suffix)
  core.irc:send (channel, suffix or "")
end

core:addCommand ("raw", raw, true)
