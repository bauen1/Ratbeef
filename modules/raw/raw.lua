local core = require ("core")

function raw (arg)
  core.luairc:raw (arg)
end

core:addCommand ("raw", raw, true)
