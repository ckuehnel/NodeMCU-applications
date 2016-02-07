-- retrieve the current time from Google
-- http://benlo.com/esp8266/esp8266Projects.html
-- tested on NodeMCU 0.9.6-dev build 20150406

function queryTime()
  conn=net.createConnection(net.TCP, 0) 

  conn:on("connection",function(conn, payload)
    conn:send("HEAD / HTTP/1.1\r\n".. 
               "Host: google.com\r\n"..
               "Accept: */*\r\n"..
               "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
               "\r\n\r\n") 
                end)
            
  conn:on("receive", function(conn, payload)
    print('Retrieved in '..((tmr.now()-t)/1000)..' milliseconds.')
    print('Google says it is '..string.sub(payload,string.find(payload,"Date: ")
           +6,string.find(payload,"Date: ")+35))
    conn:close()
    end) 
  t = tmr.now()    
  conn:connect(80,'google.com')
end

tmr.alarm(0, 10 * 1000, 1, function() queryTime() end )

print("Queries every 10 sec the time from Google server and displays it on OLED display")
print("Stop this by tmr.stop(0)")