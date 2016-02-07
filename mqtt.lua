-- Title   : Publish data to cloudmqtt.com
-- Date    : 2015-08-24
-- Id      : mqtt.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Found at: http://git.agocontrol.com/hari/esp8266-lua-snippets/blob/master/mqtt.lua
-- Modified: Claus Kuehnel

-- Defined in credentials.lua
-- CLIENTID, BROKER, BRPORT, BRUSER, BRPWD

-- Initialize pseudo-random number generator
dofile("random.lua")

print "Connecting to MQTT broker. Please wait..."

temperature = math.random(100) -- simulates values between 0 and 99
pressure = math.random(100) -- simulates values between 0 and 99

m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

m:connect( BROKER , BRPORT, 0, function(conn)
  print("Connected to MQTT:"..BROKER..":"..BRPORT.." as "..CLIENTID)
  m:publish("/sensors/"..CLIENTID.."/temperature",temperature,0,0, function(conn)
    print ("temperature value published") 
    tmr.delay(10000)
    m:publish("/sensors/"..CLIENTID.."/pressure",pressure,0,0, function(conn)
      print ("pressure value published") 
      tmr.delay(10000)
    end)
  end)
end)

m:close()
