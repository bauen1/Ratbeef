local core = require ("core")

local function reload (arg)
  core:respond ("Reloading now!")
  core.luairc:away ("Reloading modules")
  core:unloadmodules ()
  core:loadmodules ()
  core.luairc:away ("")
  core:respond ("Reload Finished")
end

core:addCommand ("reload", reload, true)
