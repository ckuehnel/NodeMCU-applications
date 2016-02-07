-- Title   : Send DHT11 data to MQTT broker
-- Date    : 2016-01-20
-- Id      : dht_mqtt.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

DHT_PIN = 4 -- defined by DHT shield

function read_DHT()
  status,temp,humi,temp_decimial,humi_decimial = dht.read(DHT_PIN)
  if( status == dht.OK ) then
    print("DHT Temperature = "..temp.." grdC  ".."Humidity = "..humi.." %")
  elseif( status == dht.ERROR_CHECKSUM ) then
    print( "DHT Checksum error." );
  elseif( status == dht.ERROR_TIMEOUT ) then
    print( "DHT Time out." );
  end
  return temp, humi
end

function sendmessage(t,h)
   m:publish("DHT11/"..CLIENTID.."/temperature",t,0,0, function(conn)
      print ("temperature value published") 
      tmr.delay(10000)
      m:publish("DHT11/"..CLIENTID.."/humidity",h,0,0, function(conn)
        print ("humidity value published")
        tmr.delay(10000)
      end)
    end)
end

function measure()
  sendmessage(read_DHT())
end

print("Measure temperature & humidity each 30 sec...")
print("Stop this by tmr.stop(0)")

m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

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
        dofile("dht_mqtt.lua")
     end)
    end)
  end)
end)








