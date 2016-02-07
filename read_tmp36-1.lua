t_old = 0 

function query()
  count = adc.read(0)
  t = ((count*3300)/1024-500)/10
  t = (math.floor(10*t + 0.5))/10 -- round to xx.x
  if t~= t_old then
    t_old = t
    print("TMP36 Temperature "..t.." deg C")
    getDateTime()
  end
end

function getDateTime()

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
    print(date.."\n")
    conn:close()
    end)   
conn:connect(80,'google.com')
end



-- queries DHT11 every 10 sec.
tmr.alarm(0, 10 * 1000, 1, function() query() end )

print("Queries TMP36 every 10 sec and prints when value changes")
print("Stop this by tmr.stop(0)")
