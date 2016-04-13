local core = require ("core")
local irccolors = require ("irccolors")

local function die (prefix, channel, suffix)
  core.irc:action (channel, irccolors.red .. "goes dieing where he is" .. irccolors.reset)
  core:disconnect ()
  os.exit (1)
end

core:addCommand ("die", die, true)
