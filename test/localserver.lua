local socket = require ("socket")

local server = socket.bind ("127.0.0.1", 6667)

while true do
  local client = server:accept ()
  print ("New client connected")
  client:settimeout (1)

  while true do
    local line, err = client:receive ("*l")

    if line then
      print ("bot  :", line)
    else
      if err == "timeout" then
        socket.sleep (0.1)
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
