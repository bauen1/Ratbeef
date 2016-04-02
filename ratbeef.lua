-- This file is full of hacky s**t

package.path = package.path .. ";./core/?.lua;./core/?" -- Hack Nr.1
local utils = require ("utils")
_G.class = utils.class -- Unclean way Nr.1
local core = require ("core")
core = core ()
package.loaded ["core"] = core -- Hack Nr.2

core:loadmodules ()
--core:connect ("127.0.0.1", 6667)
--core:start ()
core:connect () -- Uses settings.lua
core:start ()
