local core = require "core"


local function bf (prefix, channel, cmd, code, ...)
  if cmd == "reset" then

  elseif cmd == "run" then

  end
end

core:addCommand ("bf", bf, false)
core:addCommand ("brainfuck", bf, false)
