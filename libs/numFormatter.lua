func = {}

local expect = require "cc.expect"
local numChars = {"k", "M", "G", "T", "P", "E"}

local energyUnits = {["J"] = true, ["FE"] = true}
local fluidUnits = {["mB"] = true, B = true}

-- https://stackoverflow.com/questions/2282444/how-to-check-if-a-table-contains-an-element-in-lua

-- format ratio value to string in percentage
-- r: ratio, dp: decimal places(integer)
-- ex. r = 0.0123, dp = 2 : returns "1.23%"
function func.ratio(r, dp)
  expect(1, r, "number")
  expect(2, dp, "number")
  expect.range(dp, 1, 5)

  -- please insert integer
  dp = math.ceil(dp)

  local ratioFormat = "%." .. dp .. "f %%"
  return string.format(ratioFormat,r * 100)
end

-- format huge number(energy) to more readable string.
-- num: number, dp: decimal places, unit: J or FE(J by default)
-- ex1. num = 50, dp = 2, unit = "J" returns "50 J"
-- ex2. num = 15,120, dp = 2, unit = "J" returns "15.12 kJ"
function func.energy(num, dp, energyUnit)
  expect(1, num, "number")
  expect(2, dp, "number")
  expect(3, energyUnit, "string")

  if energyUnit and energyUnits[energyUnit] == nil then
    printError("Wrong Energy Unit. Use either \"J\" or \"FE\".")
    return nil
  elseif energyUnit == "FE" then
    num = mekanismEnergyHelper.joulesToFE(num)
  end

  if num < 1000 then
    local numFormat = "%d %s"
    return string.format(numFormat, num, energyUnit)
  end

  local idxChar = 1
  while num >= 999950 do 
    num = num / 1000
    idxChar = idxChar + 1
  end

  local numFormat = "%." .. dp .. "f %s%s"
  return string.format(numFormat, num/1000, numChars[idxChar], energyUnit)

end

-- format huge number(fluids) to more readable string.
-- num: number, dp: decimal places, unit: mB or B(mB by default)
-- ex1. num = 500, dp = 2, unit = "mB" returns "500 mB"
-- ex2. num = 153,120, dp = 2, unit = "B" returns "153.12 B"

function func.fluid(num, dp, fluidUnit)
  expect(1, num, "number")
  expect(2, dp, "number")
  expect(3, fluidUnit, "string")

  if fluidUnit and fluidUnits[fluidUnit] == nil then
    printError("Wrong Fluid Unit. Use either \"mB\" or \"B\".")
    return nil
  elseif fluidUnit == "B" then num = num / 1000
  end

  if num < 1000 then
    local numFormat = "%d %s"
    return string.format(numFormat, num, fluidUnit)
  end

  local idxChar = 1
  while num >= 999950 do 
    num = num / 1000
    idxChar = idxChar + 1
  end

  local numFormat = "%." .. dp .. "f %s%s"
  return string.format(numFormat, num/1000, numChars[idxChar], fluidUnit)

end

local function testEnergy()
  local test_table = {0, 50, 949, 950, 1000, 15000, 181231, 12412125}
  for _,v in ipairs(test_table) do
    print(func.energy(v, 2, "J")) 
  end
end

return func
