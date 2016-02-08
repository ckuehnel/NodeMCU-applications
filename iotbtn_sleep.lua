-- Title   : IoT Button
-- Author  : Claus Kuehnel
-- Date    : 2016-02-01
-- Id      : iotbtn_sleep.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Found at: 
-- https://www.hackster.io/fablabeu/first-esp8266-and-ifttt-integration
-- Guido Burger (http://fab-lab.eu/)
-- Modfied : Claus Kuehnel

-- IO
LED = 0
IN  = 4

voltage = 4.82*adc.read(0)/1024


-- set D4 as trigger input w/ pullup
gpio.mode(IN, gpio.INT, gpio.PULLUP)
gpio.trig(IN, "down",pincb)

-- set D0 as output w/ pullup
gpio.mode(LED, gpio.OUTPUT, gpio.PULLUP)

function pincb(level)
  if level == gpio.LOW then
    print("Button pressed")
    sendMessage(MESSAGE)
  end
end    

-- set D0 as output
gpio.mode(LED, gpio.OUTPUT)
gpio.write(LED, gpio.LOW)
tmr.delay(100)
gpio.write(LED, gpio.HIGH)

function round(num,idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + .5)/mult
end 

voltage =  round(voltage, 3)
function sendMessage(msg)
  -- conection to IFTTT channel
  print("Sending data to IFTTT channel")
  conn=net.createConnection(net.TCP, 0) 
  conn:on("receive", function(conn, payload) 
    print("Answer from IFTTT:")
    print(payload) 
  end)
  conn:connect(80,'maker.ifttt.com') 
  conn:on("connection", function(conn, payload) 
    print("Connected, sending event")
    conn:send("POST /trigger/btn_pressed/with/key/"..IFTTTKEY
    .."?value1="..voltage
    .." HTTP/1.1\r\n"
    .."Host: maker.ifttt.com\r\n"
    .."Accept: */*\r\n"
    .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.)\r\n"
    .."\r\n")
  end)

  conn:on("sent",function(conn)
    print("Message sent.")
  end)

  conn:on("disconnection", function(conn)
    print("Got disconnection...")
  end)
end


print("IoT Button pressed...")
print("Voltage = "..voltage.." V")
sendMessage()
tmr.alarm(0, 5000, tmr.ALARM_SINGLE, function() 
  print("Goto sleep...")
  node.dsleep(0) 
end)
 







