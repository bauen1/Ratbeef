local core = require ("core")

local function echo (prefix, channel, suffix)
  core:respond (channel, suffix)
end

core:addCommand ("echo", echo)
