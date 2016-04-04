-- This file is full of hacky s**t
-- TODO: Overwrite print to show the date

local utils = require ("core.utils")
_G.class = utils.class -- Unclean way Nr.1

while true do
  print ("\027[32mRatbeef\027[00m")
  local oldpath = package.path
  package.path = package.path .. ";./core/?.lua;./core/?" -- Hack Nr.1

  local core = require ("core")
  core = core ()
  package.loaded ["core"] = core -- Hack Nr.2

  core:loadmodules ()
  --core:connect ("127.0.0.1", 6667)
  --core:start ()
  core:connect () -- Uses settings.lua
  if core:start () then
    os.exit (0)
  else
    print ("RELOAD")
  end
  package.path = oldpath
  package.loaded ["core"] = nil
end
