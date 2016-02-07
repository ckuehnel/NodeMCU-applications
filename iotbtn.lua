-- Title   : IoT Button
-- Author  : Claus Kuehnel
-- Date    : 2016-02-01
-- Id      : iotbtn.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Found at: 
-- https://www.hackster.io/fablabeu/first-esp8266-and-ifttt-integration
-- Guido Burger (http://fab-lab.eu/)
-- Modfied : Claus Kuehnel

tmr.stop(0) -- stop this timer if running

-- IO
LED = 0
IN  = 4

-- set D4 as trigger input w/ pullup
gpio.mode(IN, gpio.INT, gpio.PULLUP)
gpio.trig(IN, "down",pincb)

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

function sendMessage(msg)
  -- conection to IFTTT channel
  print("Sending data to IFTTT channel")
  conn=net.createConnection(net.TCP, 0) 
  conn:on("receive", function(conn, payload) print(payload) end)
  conn:connect(80,'maker.ifttt.com') 
  conn:on("connection", function(conn, payload) 
    print("Connected, sending event")
    conn:send("POST /trigger/btn_pressed/with/key/"..IFTTTKEY
    .." HTTP/1.1\r\n"
    .."Host: maker.ifttt.com\r\n"
    .."Accept: */*\r\n"
    .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.)\r\n"
    .."\r\n")
  end)

  conn:on("sent",function(conn)
    print("Closing connection")
  end)

  conn:on("disconnection", function(conn)
    print("Got disconnection...")
  end)
end

function read_input(pin)
    state = gpio.read(pin)
    if state ~= old_state then
        old_state = state
        print("Input = "..state)
        if state == 0 then 
            gpio.write(LED, gpio.LOW)
            sendMessage(MESSAGE)
        else
            gpio.write(LED, gpio.HIGH)
        end
    end
end

read_input(IN)

-- input pin is queried every 1000ms
tmr.alarm(0, 1000, 1, function() read_input(IN) end )

print("IoT Button running...")
print("If input state changes LED connected to D0 will change too")
print("Stop this by tmr.stop(0)")


