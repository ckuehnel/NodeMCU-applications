-- Title   : Subscribe data from cloudmqtt.com
-- Date    : 2015-08-24
-- Id      : mqtt_subtemp.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Found at: http://git.agocontrol.com/hari/esp8266-lua-snippets/blob/master/mqtt.lua
-- Modified: Claus Kuehnel

-- Defined in credentials.lua
-- CLIENTID, BROKER, BRPORT, BRUSER, BRPWD

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

m:connect(BROKER, BRPORT, 0, function(conn) 
  print("Connected to MQTT:"..BROKER..":"..BRPORT.." as "..CLIENTID)
  -- subscribe topic with qos = 0
  m:subscribe("DHT11/+/temperature",0, function(conn) 
    print("subscribe success") 
  end)
  -- on publish message receive event
  m:on("message", function(conn, topic, data) 
    if data ~= nil then print(topic..":"..data) end
  end)
  -- reconnecting when offline
  m:on("offline", function(con) 
     print ("Reconnecting to MQTT:" .. BROKER) 
     -- print("Heap = " .. node.heap())
     tmr.alarm(1, 1000, 0, function()
          m:close()
          m = nil
          dofile("mqtt_subtemp.lua")
     end)
  end)
  tmr.stop(0)
  tmr.alarm(0, 60000, 1, function() sendmessage() end ) -- 60 sec
end)

function sendmessage()
  m:publish("DHT11/"..CLIENTID.."/state","in operation",0,0, function(conn) end)
end
