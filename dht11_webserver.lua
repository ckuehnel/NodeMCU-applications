-- Title   : DHT11 Webserver
-- Author  : Claus Kuehnel
-- Date    : 2015-06-06
-- Id      : dht11_webserver.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Copyright © 2015 Claus Kuehnel info[at]ckuehnel.ch

PIN = 6 -- data pin of DHT11
LED = 8 -- D8

gpio.mode(LED, gpio.OUTPUT)

DHT= require("dht11")

DHT.init(PIN)

function readDHT11()
  DHT= require("dht11")
  DHT.init(PIN)
  gpio.write(LED,gpio.LOW)
  t = DHT.getTemp()
  h = DHT.getHumidity()
  if h == nil then
    error = 1
    print("Error reading from DHT11")
  else
    error = 0
    print("Temperature: "..t.." deg C\tHumidity: "..h.."%\n\n")
  end
  gpio.write(LED,gpio.HIGH)
  DHT = nil
  package.loaded["dht11"]=nil
end

-- LUA Webserver --
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
    print("Got query...")
    print("Heap = "..node.heap().." Bytes")
    print("Time since start = "..tmr.time().." sec")
    -- print("Print payload:\n"..payload)

    reply_begin = "<html><head><title>DHT11 ESP8266 Webserver</title></head><body><h1>DHT11 Measuring Values</h1><font size=\"+2\">" 

    -- 123456789012
    -- GET /DHT11 HTTP/1.1 --
    command = string.sub(payload, 6,10) -- Get characters 6 to 10   
    if (command == "DHT11") then
      readDHT11()
      reply = reply_begin.."Temperature: "..t.." deg C<br>"
      reply = reply.."Humidity: "..h.."%"
      reply = reply.."</font></body></html>"
    else
      reply = reply_begin.."No access to data."
      reply = reply.."</font></body></html>"
    end
    payloadLen = string.len(reply)
    conn:send("HTTP/1.1 200 OK\r\n")
    conn:send("Content-Length:" .. tostring(payloadLen) .. "\r\n")
    conn:send("Connection:close\r\n\r\n")
    conn:send(reply)
    collectgarbage()
  end)
  
  conn:on("sent",function(conn)
    conn:close()
  end)
end)
