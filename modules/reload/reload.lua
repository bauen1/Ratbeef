local core = require ("core")

local function reload (prefix, channel, suffix)
  core:respond (channel, "Reloading now!")
  core.irc:away ("Reloading modules")
  core:unloadmodules ()
  core:loadmodules ()
  core.irc:away ("")
  core:respond (channel, "Reload Finished")
end

core:addCommand ("reload", reload, true)
