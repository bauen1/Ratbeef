local utils = {}

function utils.class ()
  local c={}
  c.__index = c
  setmetatable (c, {
    __call = function (cl, ...)
      local obj = {}
      setmetatable(obj,c)
      if cl.new then
        cl.new (obj, ...)
      end
      return obj
    end
  })
  return c
end

function utils.list (directory) -- Hacky pice of sh**
  local f = io.popen (string.format ("ls ./%s", directory or ""))
  local files = {}

  for name in f:lines () do -- This assumes a ls program wich prints every file on a new line
    table.insert (files, tostring(name))
  end

  local success, exitcause, number = f:close ()

  if not success then
    error (exitcause, number)
  else
    return files
  end
end

function utils.parse (line)
  -- Example:
  -- :prefix command arg1 arg2 ...
  local args,arg = {},""
  local prefix, other = string.match (line, "^:([^%s]*) (.*)$")

  if not other then -- if theres no prefix, then other will be nil
    other = line
  end

  local cmd, other = string.match (other, "^([^%s]*)(.*)$")

  -- other = "arg1 arg2 arg3 ..."

  for i=0,100 do -- FIXME: This is broken
    arg, other = string.match (other, "^([^%s]*)(.*)$")
    if arg and (arg~="") then
      table.insert (args, arg)
    end

    if not arg or not other or other=="" or arg=="" then break end
  end


  return prefix, cmd, table.pack (table.unpack(args))
end

function utils.printf (...)
  return print (string.format (...))
end

return utils
