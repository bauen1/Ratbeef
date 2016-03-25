package.path = package.path .. ";./core/?.lua;./core/?" -- FIXME use package.config
local utils = require ("utils")
_G.class = utils.class
local core = require ("core")
core = core ()

core:connect ("irc.esper.net", 6667)
