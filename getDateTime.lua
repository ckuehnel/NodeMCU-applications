-- Title   : Google Time
-- Date    : 2015-08-08
-- Id      : getDateTime.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Found at: http://benlo.com/esp8266/esp8266Projects.html
-- Modified: Claus Kuehnel 

conn=net.createConnection(net.TCP, 0) 

conn:on("connection",function(conn, payload)
conn:send("HEAD / HTTP/1.1\r\n".. 
           "Host: google.com\r\n"..
           "Accept: */*\r\n"..
           "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
           "\r\n\r\n") 
           end)           
conn:on("receive", function(conn, payload)
    date = string.sub(payload,string.find(payload,"Date: ")
           +6,string.find(payload,"Date: ")+35)
    wday = string.sub(date, 1, 3)
    day = string.sub(date, 6, 7)
    month = string.sub(date, 9, 11)
    year = string.sub(date, 13, 16)
    hour = string.sub(date, 18,19)
    min = string.sub(date, 21, 22)
    sec = string.sub(date, 24,26)
    print()
    print(day..". "..month.." "..year.."\t"..hour..":"..min..":"..sec.." GMT")
    hour = tostring(tonumber(hour) + 2)
    print(day..". "..month.." "..year.."\t"..hour..":"..min..":"..sec.." CEST")
    conn:close()
    end)  
conn:connect(80,'google.com')
