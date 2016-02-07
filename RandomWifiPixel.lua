-- Id      : Random Wifipixel
-- Date    : 2016-02-07
-- File    : RandomWifiPixel.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

BRIGHT     = 0.5
ON         = BRIGHT * 254
LED_PIN    = 8 -- 2       -- GPIO2
TIME       = 500000  -- 0.500 second,  2 Hz

r = ON ; g = ON ; b = ON

COLOR = string.char(r,  g,  b)

math.randomseed(tmr.time())
math.random(); math.random(); math.random()

function show()
  ws2812.write(LED_PIN, COLOR)
  tmr.delay(TIME)
  r = math.min(255, math.abs(r + math.ceil(math.random(-20,20))))
  g = math.min(255, math.abs(g + math.ceil(math.random(-20,20))))
  b = math.min(255, math.abs(b + math.ceil(math.random(-20,20))))
  print(r,g,b)
  COLOR = string.char(r,  g,  b) 
end


tmr.alarm(0, 500, 1, function() show() end )

print("One WS2812 connected to Pin2 will changes its color repeatedly")
print("Stop this by tmr.stop(0)")
show()
