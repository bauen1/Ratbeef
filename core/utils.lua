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

function utils.list (directory) -- Hacky pice of sh**, if you got a integrated function replace this!
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
  local words = utils.split (line)

  if words[1]:sub (1,1) == ":" then
    prefix = table.remove (words, 1)
  end

  local cmd = table.remove (words, 1)

  local args, suffix_start = {}, 0
  for i,v in ipairs (words) do
    if v:find ("^:") then
      suffix_start = i
      break
    end

    args [i] = v
  end

  local suffix
  if suffix_start == 0 then
    suffix = ""
  else
    suffix = table.concat (words, " ", suffix_start)
  end

  if suffix ~= "" then
    suffix = string.gsub (suffix, "^:", "")
  end

  return prefix, cmd, args, suffix
end

function utils.split (a)
  local ret = {}

  for w in string.gmatch (a, "[^%s]+") do
    table.insert (ret, w)
  end

  return ret
end

function utils.getNick (prefix)
  return prefix:match ("^:([^!]*)!")
end

function utils.sanitize (s)
  return string.gsub (s or "", "\a", "BELL")
end

function utils.log (...)
  return print (...)
end

return utils
