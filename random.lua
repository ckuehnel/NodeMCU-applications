-- Pseudo-random number generation

function randomInit()
  math.randomseed(tmr.now())
  math.random()
  math.random()
  math.random()
end

randomInit()

-- print(math.random(100))
