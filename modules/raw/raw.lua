local core = require ("core")

function raw (...)
  core.luairc:send (...)
end

core:addCommand ("raw", raw, true)
