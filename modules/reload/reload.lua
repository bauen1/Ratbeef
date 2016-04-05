local core = require ("core")

local function reload (prefix, channel, suffix)
  core:action (channel, "reloads")
  core:unloadmodules ()
  core:loadmodules ()
end

core:addCommand ("reload", reload, true)
