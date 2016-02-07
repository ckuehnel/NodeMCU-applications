-- Date    : 2015-09-14
-- Id      : pir_sub_mqtt.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Found at: http://git.agocontrol.com/hari/esp8266-lua-snippets/blob/master/mqtt.lua
-- Modified: Claus Kuehnel

-- Defined in credentials.lua
-- CLIENTID, BROKER, BRPORT, BRUSER, BRPWD

REL = 1 -- Relay of ESP8266-EVB is connected to GPIO5

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

-- m:on("offline", function(con) print ("offline") end)
m:on("offline", function(con) 
     print ("Reconnecting to MQTT:" .. BROKER) 
     print("Heap = " .. node.heap())
     tmr.alarm(1, 1000, 0, function()
          m:connect(BROKER, BRPORT, 0)
     end)
end)

m:connect(BROKER, BRPORT, 0, function(conn) 
    print("Connected to MQTT:" .. BROKER .. ":" .. BRPORT .." as " .. CLIENTID )
    -- subscribe topic with qos = 0
    m:subscribe("/pir/".. PUBLISHERID .. "/state",0, function(conn) 
      print("subscribe success") 
    end)
    -- on publish message receive event
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic..":"..data)
        if data == "0" then
          print("No further movement")
          gpio.write(REL, gpio.LOW)
        else
          print("Movement detected")
          gpio.write(REL, gpio.HIGH)
        end
      end
    end)
end)
