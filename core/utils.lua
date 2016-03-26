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

function utils.printf (...)
  return print (string.format (...))
end

return utils
