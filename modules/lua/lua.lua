local core = require "core"

local task = coroutine.create (function ()


end)
coroutine.resume (task)

local function eval_lua (arg)
  -- TODO: Implement a Sandbox (better than vifinos :P and don't include backdoors)
  local out = coroutine.resume (arg)
  core:respond (out)
end

local function reset_lua (arg)

end

core:addCommand ("lua", eval_lua, true)
core:addCommand ("reset_lua", reset_lua, true)
