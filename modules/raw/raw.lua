local core = require ("core")

function raw (arg)
  local s,e = string.find ("{(.*)}") -- {msg here}
  core.luairc:raw (string.sub (arg, s, e))
end

core:addCommand ("raw", raw, true)
