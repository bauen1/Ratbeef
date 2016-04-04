local core = require ("core")

local function die (prefix, channel, suffix)
  core.irc:action (channel, "goes dieing where he is")
  core:disconnect ()
  os.exit (1)
end

core:addCommand ("die", die, true)
