local core = require ("core")

local function reload (prefix, channel, suffix)
  core:respond (channel, "Will be back in a few secs (full reload)")
  core:disconnect ("reload")
  core.reload = true
end

core:addCommand ("reload", reload, true)
