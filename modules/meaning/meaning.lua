local core = require ("core")

local function echo (prefix, channel, ...)
  core:respond (channel, "My life meaning: Marry Ratbot!")
end

core:addCommand ("meaning", echo)
