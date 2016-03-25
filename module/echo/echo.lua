local core = require ("core")

local function echo (arg)
  core.respond (arg)
end


core.addCommand ("echo",echo)
