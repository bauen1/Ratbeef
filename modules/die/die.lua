local core = require ("core")

local function die (arg)
  core:respond ("*goes dieing where he is*")
  core:disconnect ()
  os.exit (1)
end

core:addCommand ("die", die, true)
