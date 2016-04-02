local core = require ("core")

local function reload (prefix, channel, ...)
  core:respond (channel, "Reloading now!")
  core.luairc:away ("Reloading modules")
  core:unloadmodules ()
  core:loadmodules ()
  core.luairc:away ("")
  core:respond (channel, "Reload Finished")
end

core:addCommand ("reload", reload, true)
