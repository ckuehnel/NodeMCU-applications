-- Title   : Asks for latest dweet 
-- Date    : 2015-07-30
-- Id      : get_dweet.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

HOST = "dweet.io"

LED = 8 -- D8

-- set gpio 0 as output.
gpio.mode(LED, gpio.OUTPUT)
gpio.write(LED, gpio.HIGH)

function printResponse(pl)
  local i = 0
  local j = 0
  print("response: ",pl)
  i = string.find(pl, "200 OK")
  if i ~= nil then
    _, i = string.find(pl, "state")
    state = string.sub(pl, i+3, i+3) 
  end  
end

function get_last_dweet()
  conn=net.createConnection(net.TCP,0) 
  conn:on("receive", function(conn, pl) printResponse(pl) end)
  conn:on("connection", function(conn, payload) 
          print("connected") 
          conn:send("GET /get/latest/dweet/for/mySwitch"
          .. " HTTP/1.1\r\n"
          .. "Host: " .. HOST .. "\r\n"
          .. "Connection: close\r\n"
          .. "Accept: */*\r\n\r\n") end)
  conn:on("disconnection", function(conn, payload)
          print("disconnected") 
          gpio.write(LED, state) end)
  conn:connect(80, HOST)
end

-- get_last_dweet()

-- asks for latest dweet every 60 sec. and controls D8
tmr.alarm(0, 60 * 1000, 1, function() get_last_dweet() end )

print("Asks every 60 sec for the latest dweet from dweet.io")
print("Stop this by tmr.stop(0)")
 
