-- Title   : Send DHT11 data to dweet.io
-- Date    : 2016-01-03
-- Id      : DHT11_dweet.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

DHT_PIN = 4 -- defined by DHT shield
HOST    = "dweet.io"

function read_DHT()
  status,temp,humi,temp_decimial,humi_decimial = dht.read(DHT_PIN)
  if( status == dht.OK ) then
    print("DHT Temperature = "..temp.." grdC  ".."Humidity = "..humi.." %")
  elseif( status == dht.ERROR_CHECKSUM ) then
    print( "DHT Checksum error." );
  elseif( status == dht.ERROR_TIMEOUT ) then
    print( "DHT Time out." );
  end
end

function dweet()
  read_DHT()
  conn=net.createConnection(net.TCP,0) 
  conn:on("receive", function(conn, pl) print("response: ",pl) end)
  conn:on("connection", function(conn, payload) 
          print("connected") 
          conn:send("POST /dweet/for/myDHT?"
          .. "temperature=" .. temp 
          .. "&humidity=" .. humi 
          .. " HTTP/1.1\r\n"
          .. "Host: " .. HOST .. "\r\n"
          .. "Connection: close\r\n"
          .. "Accept: */*\r\n\r\n") end)
  conn:on("disconnection", function(conn, payload)
          print("disconnected") end)
  conn:connect(80, HOST)
end

dweet()

-- dweets every 60 sec.
tmr.alarm(0, 60 * 1000, 1, function() dweet() end )

print("Dweets every 60 sec DHT11 data to dweet.io")
print("Stop this by tmr.stop(0)")