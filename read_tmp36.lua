-- Title   : Read TMP36 temperature sensor
-- Author  : Claus Kuehnel
-- Date    : 2015-06-01
-- Id      : read_tmp36.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Copyright © 2015 Claus Kuehnel info[at]ckuehnel.ch

-- NodeMCU has 3.3 V input range
-- in case of 1 V conncet TMP36 output via voltage divider to TOUT (4.1 k/5.6 k)

print("Reading TMP36 Sensor")

count = adc.read(0)
--print(count)

temperature = ((count*3300)/1024-500)/10
-- temperature = ((count*1000)/1024-500)/10
print("Temperature = "..temperature.." °C")

