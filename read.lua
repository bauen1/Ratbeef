local args = {...}
local stdout_name = args[1]
assert (stdout_name)

local stdout = assert (io.open (stdout_name, "w"))
stdout:setvbuf ("line", 4096)

--local history = {}

function readLine ()
  local inline = ""
  local running = true

  while running do
    local byte = io.read (1)
    if not byte then return nil end

    if byte == "\n" then
      running = false
    elseif byte == "\27" then
      local byte2 = io.read (1)

      if byte2 == "\91" then
        local byte3 = io.read (1)

        -- TODO: Implement (Needs custom drawing logic)
        if byte == "\65" then -- A up
          -- TODO: Implement
        elseif byte == "\66" then -- B down
          -- TODO: Implement
        elseif byte == "\67" then -- C right
          -- TODO: Implement
        elseif byte == "\68" then -- D left
          -- TODO: Implement
        end

        byte = ""
      else
        byte = byte .. byte2
      end
    end

    inline = inline .. byte
  end

  return inline
end

while true do
  local line = readLine ()

  if not line then return end

  --table.insert (history, line)
  stdout:write (line)
  stdout:flush ()
end
