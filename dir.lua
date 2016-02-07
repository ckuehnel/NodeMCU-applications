-- Title   : List all files
-- Date    : 2015-06-01
-- Id      : dir.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Found at: https://github.com/annejan/nodemcu-lua-watch
-- Modified: Claus Kuehnel 

-- Lists all files stored on ESP8266 device
print("Listing all files on ESP8266 device:")
l = file.list();
for k,v in pairs(l) do
  print(k.. "\t"..v.." Bytes")
end
l = nil
