local core = require ("core")

local function echo (prefix, channel, ...)
  core:respond (channel, table.concat ({...}," " ))
end

core:addCommand ("echo", echo)
