-- Title   : Lists Access Points
-- Date    : 2015-07-30
-- Id      : getAPs.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel 

-- print ap list
function listap(t)
  print("\nVisible Access Points:")
  print("SSID  Authmode  RSSI  BSSID  Channel") 
  for ssid,v in pairs(t) do
    authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
    print(ssid,authmode,rssi,bssid,channel)
  end
end

wifi.sta.getap(listap)
