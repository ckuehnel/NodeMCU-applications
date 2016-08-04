-- Title   : Subscribe data from cloudmqtt.com for sonoff module
-- Date    : 2016-06-30
-- Id      : sonoff.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Found at: http://git.agocontrol.com/hari/esp8266-lua-snippets/blob/master/mqtt.lua
-- Modified: Claus Kuehnel

-- Defined in credentials.lua
-- CLIENTID, BROKER, BRPORT, BRUSER, BRPWD


REL=6  -- GPIO12 (MTDI)
LED=7  -- GPIO13 (MTCK)

gpio.mode(REL, gpio.OUTPUT)
gpio.mode(LED,gpio.OUTPUT)
gpio.write(REL, gpio.LOW) 
gpio.write(LED, gpio.HIGH)

state = 0

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

m:lwt("SONOFF/"..CLIENTID.."/lwt", " now offline", 0, 0)

m:connect(BROKER, BRPORT, 0, function(conn) 
  print("Connected to MQTT:"..BROKER..":"..BRPORT.." as "..CLIENTID)
  -- subscribe topic with qos = 0
  m:subscribe("SONOFF/".. CLIENTID .."/state",0, function(conn) 
    print("subscribe success") 
  end)
  -- on publish message receive event
  m:on("message", function(conn, topic, data) 
    if data ~= nil then 
      print(topic..":"..data)
      state = data 
      if data == "0" then
        gpio.write(REL, gpio.LOW)
        gpio.write(LED, gpio.HIGH)
      else
        gpio.write(REL, gpio.HIGH)
        gpio.write(LED, gpio.LOW)
      end
    end
  end)
  -- reconnecting when offline
  m:on("offline", function(con) 
     print ("Reconnecting to MQTT:" .. BROKER) 
     -- print("Heap = " .. node.heap())
     tmr.alarm(1, 1000, 0, function()
          m:close()
          m = nil
          dofile("sonoff.lua")
     end)
  end)
  tmr.stop(0)
  tmr.alarm(0, 60000, 1, function() sendmessage() end ) -- 60 sec
end)

function sendmessage()
  m:publish("SONOFF/"..CLIENTID.."/state", state,0,0, function(conn) end)
end
