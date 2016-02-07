-- Title   : Digital In/Output
-- Date    : 2015-06-07
-- Id      : dio1.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Created : Claus Kuehnel info[at]ckuehnel.ch

-- Connect LED & resistor to Pin2 (D2) of NodeMCU
-- Connect PIR Output to Pin1 (D1) of NodeMCU

LED = 2 -- D2
IN  = 1 -- D1 

old_state = 1

-- set gpio 2 as output.
gpio.mode(LED, gpio.OUTPUT)

-- CLIENTID = "ESP8266-" ..  node.chipid()

print "Connecting to MQTT broker. Please wait..."
-- init mqtt client with keepalive timer 120sec
m = mqtt.Client(CLIENTID, 120, BRUSER, BRPWD)

-- setup Last Will and Testament (optional)
-- Broker will publish a message with:
-- qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(con) print ("connected") end)
m:on("offline", function(con) print ("offline") end)

-- on publish message receive event
m:on("message", function(conn, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

-- for secure: m:connect("192.168.11.118", 1880, 1)
m:connect(BROKER, BRPORT, 0, function(conn) 
    print("Connected to MQTT:"..BROKER..":"..BRPORT.." as "..CLIENTID)
end)

-- set gpio 1 as input w/ pullup
gpio.mode(IN, gpio.INPUT, gpio.PULLUP)

function read_input(pin)
    state = gpio.read(IN)
    if state ~= old_state then
        old_state = state
        print("PIR State = "..state)
        if state == 1 then 
            gpio.write(LED, gpio.LOW)
            m:publish("/pir/"..CLIENTID.."/state",state,0,0, function(conn) end)
        else
            gpio.write(LED, gpio.HIGH)
            m:publish("/pir/"..CLIENTID.."/state",state,0,0, function(conn) end)
        end
    end
end

-- input pin is queried every 1000ms
tmr.alarm(0, 1000, 1, function() read_input(IN) end )

print("If input state changes LED connected to Pin8 will change too")
print("Stop this by tmr.stop(0)")
