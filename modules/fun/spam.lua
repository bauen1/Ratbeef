local core = require ("core")

local function spam (prefix, channel, suffix)
  core:respond (channel, "SPAM SPAM SPAM SPAM SPAM SPAM")
end

core:addCommand ("spam", spam, true)
