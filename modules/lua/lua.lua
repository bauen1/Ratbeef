local core = require "core"

local function eval_lua (arg)
  -- TODO: Implement a Sandbox (better than vifinos :P and dont include backdoors)
end

core:addCommand ("lua", eval_lua, true)
