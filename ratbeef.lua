-- This file is full of hacky s**t

-- Most awsome hack in the history of lua
-- TODO: This might be replaced by a lua script for more "cross platform combability" :P

local stdin_name = os.tmpname ()

print ("stdin_name: '" .. stdin_name .. "'")

cmd = io.popen ("lua ./read.lua " .. stdin_name, "r")
_G.stdin = io.open (stdin_name, "r")
local oldstdin = io.input ()
local oldread = io.read
_G.io.read = function (...)
  return stdin:read (...)
end
_G.input = function ()
  return stdin
end

local cleanup_table = setmetatable ({}, {__gc=function()
  print ("Closing stdin file:")
  print (pcall (stdin.close, stdin))
  print (pcall (os.remove, stdin_name))
  print ("Closing async stdin listener:")
  print (pcall (cmd.close, cmd))
end})


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
