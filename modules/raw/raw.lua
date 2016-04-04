local core = require ("core")

local function raw (prefix, channel, suffix)
  core.irc:send (suffix or "")
end

core:addCommand ("raw", raw, true)
