local core = require ("core")

local function echo (arg)
  core:respond ("echo was called with: " .. arg)
end

core:addCommand ("echo", echo)
