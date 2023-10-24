local expect = require "cc.expect".expect

local switchStatus = {
  {name = "Matrix Dumper", side = "right", enabled = false, colors = {on = {tColor = nil, bColor = nil}, off = {tColor = nil, bColor = nil}}},
  {name = "Turbine Dumper", side = "left", enabled = false, colors = {on = {tColor = nil, bColor = nil}, off = {tColor = nil, bColor = nil}}}
}

local matrix_cfg = { upper = 0.8, lower = 0.4}

-- matrix 에너지 충전레벨 측정
-- upper보다 높으면 true, lower보다 낮으면 false
-- 만약 이도저도 아니면, 원래의 값을 유지
local function evalMatrix(ratio, oldStatus)
  expect(1, ratio, "number")
  expect(2, oldStatus, "boolean")
  if ratio > matrix_cfg.upper then
    return true
  elseif ratio < matrix_cfg.lower then
    return false
  else return oldStatus
  end
end

-- 스위치 1을 켤 것인가 (매트릭스 -> 낭비)
local function controlSwitch1(ratio, oldStatus)
  return evalMatrix(ratio, oldStatus)
end


-- 터빈, 매트릭스의 관계가 위험한가
-- turbine Energy > 0일 때
-- turbien Cur Gen > matrix transfer capacity이면서, matrix input percentage > 0.9 이상일 때
local function evalTurbine(turbineEnergy, turbineCurGen, matrixTransferCap, matrixInPer)
  if turbineEnergy > 0 then return true end
  if turbineCurGen > matrixTransferCap and matrixInPer > 0.9 
  then return true end
  return false
end

-- 스위치 2를 켤 것인지 (터빈 -> 매트릭스로 전송되는 에너지 가로채기)
-- 
local function controlSwitch2(turbineEnergy, turbineCurGen, matrixTransferCap, matrixInPer)
  return evalTurbine(turbineEnergy, turbineCurGen, matrixTransferCap, matrixInPer)
end

local function executeSwitch()
  for i = 1,#switchStatus do
    redstone.setOutput(switchStatus[i].side, switchStatus[i].enabled)
  end
end

--- Warnings

local warningStatus = {
  {name = {disabled = "Matrix Energy < 60%", enabled = "Matrix Energy > 60%"}, enabled = false, color = nil},
  {name = {disabled = "Turbine Energy = 0%", enabled = "Turbine Energy > 0%"}, enabled = false, color = nil},
  {name = {disabled = "Turbin Gen < Matrix Input Cap", enabled = "Turbine Gen > Matrix Input Cap"}, enabled = false, color = nil}
}

local function warnMatrixEnergy(ratio)
  if ratio > 0.6 then return true
    else return false
  end
end

local function warnTurbineEnergy(ratio)
  if ratio > 0 then return true
  else return false
  end
end

local function warnTooMuchGenThanMatrixCap(curGen, cap)
  if curGen > cap then return true
  else return false
  end
end

---@nodiscard
---@return table
---@param stats table
function evaluateStatus(stats)
  -- switch part
  local matrixEnergyPercentage = stats.matrix.ratio.getEnergyFilledPercentage
  local oldStatus = switchStatus[1].enabled
  switchStatus[1].enabled = controlSwitch1(matrixEnergyPercentage, oldStatus)
  

  local turbineEnergy = stats.turbine.fe.getEnergy
  local turbineCurGen = stats.turbine.fe.getProductionRate
  local matrixTransferCap = stats.matrix.fe.getTransferCap
  local matrixInPer = stats.matrix.ratio.getInputEnergyPercentage
  
  switchStatus[2].enabled = controlSwitch2(turbineEnergy, turbineCurGen, matrixTransferCap, matrixInPer)
  
  executeSwitch()

  -- warnings part
  warningStatus[1].enabled = warnMatrixEnergy(matrixEnergyPercentage)

  local turbineEnergyFilledPercentage = stats.turbine.ratio.getEnergyFilledPercentage
  warningStatus[2].enabled = warnTurbineEnergy(turbineEnergyFilledPercentage)

  warningStatus[3].enabled = warnTooMuchGenThanMatrixCap(turbineCurGen, matrixTransferCap)

  local status = {switch = switchStatus, warning = warningStatus}
  
  return status
end

return {eval = evaluateStatus}