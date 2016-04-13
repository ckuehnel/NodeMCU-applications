-- Title   : AM2315 Node
-- Author  : Claus Kuehnel
-- Date    : 2016-04-12
-- Id      : am2315_node.lua
-- Firmware: NodeMCU Custom build by frightanic.com
-- Modules : adc,file,gpio,i2c,net,node,tmr,wifi

-- load AM2315 module & init I2C bus
am2315 = require("am2315")
sda = 3 
scl = 2
am2315.init(sda, scl)

-- IO
LED = 8 

-- set D8 as output w/ pullup
gpio.mode(LED, gpio.OUTPUT, gpio.PULLUP)

gpio.write(LED, gpio.LOW)
tmr.delay(100)
gpio.write(LED, gpio.HIGH)

function round(num,idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + .5)/mult
end 

adc = adc.read(0)
voltage = 5.0*adc/1024
voltage =  round(voltage, 2)

temp, humi = 25.5, 66.6 -- am2315.getData()
print(string.format (">>> %4.2f", voltage), temp, humi, node.heap())

HOST = "api.thingspeak.com"

function sendData()
  -- conection to thingspeak.com
  print("Sending data to thingspeak.com")
  conn=net.createConnection(net.TCP, 0)
  conn:on("receive", function(conn, pl) print("response: ",pl) end)

  conn:on("connection", function(conn, payload) 
    print("connected") 
    conn:send("GET /update?"
      .. "key=" .. THINGSPEAKKEY
      .. "&field1=" .. string.format ("%4.2f", voltage) 
      .. "&field2=" .. temp 
      .. "&field3=" .. humi
      .. " HTTP/1.1\r\n"
      .. "Host: " .. HOST .. "\r\n"
      .. "Connection: close\r\n"
      .. "Accept: */*\r\n\r\n") end)
  conn:on("sent",function(conn) print("Closing connection") conn:close() end)
  conn:on("disconnection", function(conn, payload)
    print("disconnected") 
    am2315 = nil
    package.loaded["am2315"]=nil 
--    wifi.sta.disconnect()  
  end)
  conn:connect(80, HOST)
end

print("Measure temperature & humidity periodically...")
print("Stop this by tmr.stop(0)")
sendData()

pause_min = .5
pause_sec = pause_min * 60
pause_usec = pause_sec *1000 *1000

tmr.alarm(0, 5000, tmr.ALARM_SINGLE, function() 
  print("Goto sleep for "..pause_sec.." sec")
  node.dsleep(pause_usec,4) 
end)
