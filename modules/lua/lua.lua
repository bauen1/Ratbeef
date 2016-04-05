local core = require ("core")
local utils = require ("utils")

local function eval_lua (prefix, channel, suffix)
  local f, r = load (suffix, "=(IRC)", "t", _G)

  if not f then
    core:respond (channel, r)
  else
    local ret = table.pack (pcall (f, utils.getNick (prefix), channel, suffix))

    if not ret[1] then
      core:respond (channel, ret[2])
    else
      core:respond (channel, table.concat (ret, "   ", 2))
    end
  end
end

core:addCommand ("lua", eval_lua, true)
