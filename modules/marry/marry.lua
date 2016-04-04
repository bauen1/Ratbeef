local core = require ("core")
local utils = require ("utils")

local function marry (prefix, channel, suffix)
  local target = utils.split (suffix)[1] or "me"

  if (target == "me") or (target == "me!") then
    target = utils.getNick (prefix) or prefix
  end

  core:respond (channel, string.format ("%s: marry me!", target))
end

core:addCommand ("marry", marry)
