local core = require ("core")

function raw (...)
  core.luairc:raw (...)
end

core:addCommand ("raw", raw, true)
