local matrixPort = "inductionPort_1"
local turbinePort = "turbineValve_0"

local matrix = peripheral.wrap(matrixPort)
local turbine = peripheral.wrap(turbinePort)

local matrix_fe_methods = {"getMaxEnergy", "getEnergy", "getTransferCap", "getLastInput", "getLastOutput"}
local matrix_ratio_methods = {"getEnergyFilledPercentage"}

local turbine_fe_methods = {"getProductionRate", "getMaxProduction", "getEnergy", "getMaxEnergy"}
local turbine_fluid_methods = {"getSteamCapacity", "getSteam"}
local turbine_ratio_methods = {"getSteamFilledPercentage", "getEnergyFilledPercentage"}


function readStats()
  -- read from matrix
  local matrixStats = { fe = {}, ratio = {} }

  -- fe values
  for _,v in ipairs(matrix_fe_methods) do
    matrixStats.fe[v] = matrix[v]()
  end

  -- ratio values
  for i,v in ipairs(matrix_ratio_methods) do
    matrixStats.ratio[v] = matrix[v]()
  end

  -- custom ratio values
  matrixStats.ratio.getInputEnergyPercentage = matrixStats.fe.getLastInput / matrixStats.fe.getTransferCap
  matrixStats.ratio.getOutputEnergyPercentage = matrixStats.fe.getLastOutput / matrixStats.fe.getTransferCap

  local turbineStats = {fe = {}, ratio = {} , fluid = {}}
  
  -- fe values
  for _,v in ipairs(turbine_fe_methods) do
    turbineStats.fe[v] = turbine[v]()
  end

  -- fluid values
  for _,v in ipairs(turbine_fluid_methods) do
    turbineStats.fluid[v] = turbine[v]()
  end
  
  -- ratio and custom ratio values
  for _, v in ipairs(turbine_ratio_methods) do
    turbineStats.ratio[v] = turbine[v]()
  end

  turbineStats.ratio.getEnergyProductionPercentage = turbineStats.fe.getProductionRate / turbineStats.fe.getMaxProduction

  local stats = {matrix = matrixStats, turbine = turbineStats}
  
  return stats
  
  end

return {read = readStats}
