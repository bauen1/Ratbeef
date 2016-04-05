local core = require ("core")

local function echo (prefix, channel, suffix)
  core:respond (channel, "My life meaning: Marry Ratbot!")
end

core:addCommand ("meaning", echo)
