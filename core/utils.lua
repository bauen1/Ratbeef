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

return utils
