local core = require ("core")

local function echo (prefix, channel, suffix)
  core:respond (channel, core.settings.output_prefix .. suffix)
end

core:addCommand ("echo", echo)
