-- Title   : Timer
-- Author  : Claus Kuehnel
-- Date    : 2016-02-24
-- Id      : timer.lua
-- Firmware: nodemcu_float_0.9.6-dev_20150704

PERIOD = 5 * 60 * 1000 -- value in msec

-- IO
REL = 1  -- D1 Relais is controlled by D1

-- set D1 as output
gpio.mode(REL, gpio.OUTPUT, gpio.PULLUP)
gpio.write(REL, gpio.LOW)

-- REL control
function REL_on()
  gpio.write(REL, gpio.HIGH)
end

function REL_off()
  gpio.write(REL, gpio.LOW)
end

function switchRelais()
  print("Relais switched")
  REL_on()
  tmr.alarm(1, 100, tmr.ALARM_SINGLE, function() REL_off() end )
end

print("Start Timer for D1 Relais Shield...")
switchRelais()

-- REL is switched every one minute
tmr.alarm(0, PERIOD, tmr.ALARM_AUTO, function() switchRelais() end )
