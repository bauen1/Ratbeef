local socket = require ("socket")

local server = socket.bind ("127.0.0.1", 6667)

function req_input (client)
  io.write (">")
  local l = io.read ()
  if l == "" then return end
  client:send (l.."\n")
end

while true do
  local client = server:accept ()
  print ("New client connected")
  client:settimeout (1)

  while true do
    local line, err = client:receive ("*l")

    if line then
      print ("bot  :", line)
      req_input (client)
    else
      if err == "timeout" then
        socket.sleep (0.1)
        req_input (client)
      elseif err == "closed" then
        break
      else
        client:close ()
        server:close ()
        print (err)
      end
    end
  end

  client:close ()
end

server:close ()
