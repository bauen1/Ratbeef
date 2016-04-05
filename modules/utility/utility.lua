local core = require "core"

local function hate (prefix, channel, suffix)
end

local function like (prefix, channel, suffix)
end

local function love (prefix, channel, suffix)
end

core:addCommand ("hate", hate, true)
core:addCommand ("like", like, true)
core:addCommand ("love", love, true)
