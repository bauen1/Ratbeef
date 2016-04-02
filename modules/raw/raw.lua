local core = require ("core")

function raw (prefix, channel, ...)
  core.luairc:send (table.concat ({...}, " "))
end

core:addCommand ("raw", raw, true)
