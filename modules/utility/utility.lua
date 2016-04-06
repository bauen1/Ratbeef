local core = require "core"
local utils = require "utils"
local socket = require "socket"

local function hate (prefix, channel, suffix)
end

local function like (prefix, channel, suffix)
end

local function love (prefix, channel, suffix)
end

core:addCommand ("hate", hate, true)
core:addCommand ("like", like, true)
core:addCommand ("love", love, true)

core:addCommand ("info", function (prefix, channel, suffix)
  core:respond (channel, "Info command called, dunno what to add here - bauen1")
end)
