-- Title   : Send AM2315 data to MQTT broker
-- Date    : 2016-04-06
-- Id      : am2315_mqtt.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

am2315 = nil
package.loaded["am2315"]=nil

-- AM2315 connected via Grove Arduino shield to Wemos D1
am2315 = require("am2315")
sda = 2 
scl = 1
am2315.init(sda, scl)

-- Get temperature and humidity.
function read_AM2315()
  temp,humi = am2315.getData()
  print("AM2315 Temperature = "..temp.." grdC  ".."Humidity = "..humi.." %")
  return temp, humi
end

function sendmessage(t,h)
   m:publish("DHT11/"..CLIENTID.."/temperature",t,0,0, function(conn)
      print ("temperature value published") 
      tmr.delay(1000)
      m:publish("DHT11/"..CLIENTID.."/humidity",h,0,0, function(conn)
        print ("humidity value published")
        tmr.delay(1000)
      end)
    end)
end

function measure()
  sendmessage(read_AM2315())
end

print("Measure temperature & humidity each 30 sec...")
print("Stop this by tmr.stop(0)")

m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

m:lwt("DHT11/"..CLIENTID.."/lwt", " now offline", 0, 0)

m:connect(BROKER , BRPORT, 0, function(conn)
  print("Mqtt Connected to:" .. BROKER)
end)

m:on("connect", function(con)
  print("Connected to MQTT:"..BROKER..":"..BRPORT.." as "..CLIENTID)
  tmr.stop(0)
  measure()
  tmr.alarm(0, 30000, 1, function() measure() end ) -- 30 sec
end)
-- reconnecting when offline
m:on("offline", function(con)
  print ("Reconnecting to MQTT:" .. BROKER) 
  -- print("Heap = " .. node.heap())
  tmr.alarm(1, 10000, 0, function()
    m:connect(BROKER , BRPORT, 0, function(conn)
      tmr.alarm(1, 1000, 0, function()
        m:close()
        m = nil
        dofile("am2315_mqtt.lua")
     end)
    end)
  end)
end)








