-- Title   : Subscribe data from cloudmqtt.com
-- Date    : 2015-08-24
-- Id      : mqtt_sub.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Found at: http://git.agocontrol.com/hari/esp8266-lua-snippets/blob/master/mqtt.lua
-- Modified: Claus Kuehnel

-- Defined in credentials.lua
-- CLIENTID, BROKER, BRPORT, BRUSER, BRPWD

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

m:connect(BROKER, BRPORT, 0, function(conn) 
    print("Connected to MQTT:" .. BROKER .. ":" .. BRPORT .." as " .. CLIENTID )
	-- subscribe topic with qos = 0
    m:subscribe("/topic",0, function(conn) 
      print("subscribe success") 
    end)
	-- on publish message receive event
	m:on("message", function(conn, topic, data) 
	  if data ~= nil then
        print(topic..":"..data)
	  end
	end)
end)
