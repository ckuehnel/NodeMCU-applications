-- Title   : Send data to dweet.io
-- Date    : 2015-07-30
-- Id      : dweet.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

-- Initialize pseudo-random number generator
dofile("random.lua")

HOST = "dweet.io"

function dweet()
  temp = math.random(100) -- simulates values between 0 and 99
  conn=net.createConnection(net.TCP,0) 
  conn:on("receive", function(conn, pl) print("response: ",pl) end)
  conn:on("connection", function(conn, payload) 
          print("connected") 
          conn:send("POST /dweet/for/myNodeMCU?"
          .. "temperature=" .. temp 
  --        .. "&hum=" .. hum 
          .. "&heap=" .. node.heap()
          .. " HTTP/1.1\r\n"
          .. "Host: " .. HOST .. "\r\n"
          .. "Connection: close\r\n"
          .. "Accept: */*\r\n\r\n") end)
  conn:on("disconnection", function(conn, payload)
          print("disconnected") end)
  conn:connect(80, HOST)
end

-- dweets every 60 sec.
tmr.alarm(0, 60 * 1000, 1, function() dweet() end )

print("Dweets every 60 sec a pseudo-random number to dweet.io")
print("Stop this by tmr.stop(0)")
