-- Id      : Rainbow
-- Date    : 2016-02-08
-- File    : rainbow1.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704
-- Created : Claus Kuehnel

LED_PIN    = 8 -- 2       -- GPIO2

FILENAME = "rainbow.dat"
loadfile(FILENAME)

i = 0

function readTables(fname)
  print("\nRainbowTables reading from "..FILENAME)
  f = file.open(fname, "r")
--  io.input(file)
  line = file.readline() pts = tonumber(line) print("Data points = ", pts)
  green = {}
  for i = 1, pts do line = file.readline() green[i] = tonumber(line) end
--  for i, v in ipairs(green) do print(i, v) end
  red = {}
  for i = 1, pts do line = file.readline() red[i] = tonumber(line) end
--  for i, v in ipairs(red) do print(i, v) end
  blue = {}
  for i = 1, pts do line = file.readline() blue[i] = tonumber(line) end
--  for i, v in ipairs(blue) do print(i, v) end
  file.close(f)
end


function show()
  i = (i % table.getn(green))+1
  print(i, red[i], green[i], blue[i])
  COLOR = string.char(red[i],  green[i],  blue[i]) 
  ws2812.write(LED_PIN, COLOR)
end

readTables(FILENAME)

tmr.alarm(0, 100, 1, function() show() end )

print("One WS2812 connected to Pin2 will changes its color repeatedly")
print("Stop this by tmr.stop(0)")
show()
