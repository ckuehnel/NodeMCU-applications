-- Title   : Digital Output
-- Date    : 2015-06-01
-- Id      : dio.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150406
-- Created : Claus Kuehnel info[at]ckuehnel.ch

-- Connect LED & resistor to Pin8 (D8) of NodeMCU
LED = 8 -- D8

state = 0

-- set gpio 0 as output.
gpio.mode(LED, gpio.OUTPUT)

function toogle_output(pin)
    if state == 0 then
        gpio.write(LED, gpio.HIGH)
    else
        gpio.write(LED, gpio.LOW)
    end

    state = (state + 1)%2
end

-- toggles LED at pin 8 every 1000ms
tmr.alarm(0, 1000, 1, function() toogle_output(LED) end )

print("LED connected to Pin8 will be toggled every second")
print("Stop this by tmr.stop(0)")
