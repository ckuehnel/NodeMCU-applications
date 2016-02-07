-- Title   : Read DHT from DHT shield
-- Date    : 2015-12-31
-- Id      : dht.lua
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
end

read_DHT()

-- reads DHT sensor every 60 sec.
tmr.alarm(0, 60 * 1000, 1, function() read_DHT() end )

print("Reads the DHT sensor every 60 sec")
print("Stop this by tmr.stop(0)")