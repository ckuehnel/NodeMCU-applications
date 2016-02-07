-- Title   : Read DHT11 sensor
-- Author  : Claus Kuehnel
-- Date    : 2015-06-06
-- Id      : read_dht11.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Copyright © 2015 Claus Kuehnel info[at]ckuehnel.ch

PIN = 6 --  data pin of DHT11

DHT= require("dht11")

DHT.init(PIN)

print("Reading DHT11")

t = DHT.getTemp()
h = DHT.getHumidity()

if h == nil then
  print("Error reading from DHT11/22")
else
  -- temperature in degrees Celsius  and Farenheit
  -- floating point and integer version:
  print("Temperature: "..t.." deg C")
  -- print("Temperature: "..(9 * temp / 50 + 32).." deg F")

  -- humidity
  print("Humidity: "..h.."%")
end

-- release module
DHT = nil
package.loaded["dht11"]=nil

