local formatter = require "libs.numFormatter"
local aligner = require "libs.textAlign"

local mon = peripheral.wrap("monitor_1")
local reset_colors = require("libs.mon_control").reset



function update(graph_coords, graph_data, status_data)
  mon.setTextScale(0.5)
  oldTerm = term.redirect(mon)

  --- draw matrix bars
  local matrixMax = graph_data.matrix.fe.getMaxEnergy
  local matrixCur = graph_data.matrix.fe.getEnergy
  local matrixTransferCap = graph_data.matrix.fe.getTransferCap
  local matrixInput = graph_data.matrix.fe.getLastInput
  local matrixOutput = graph_data.matrix.fe.getLastOutput

  local matrixTotPer = graph_data.matrix.ratio.getEnergyFilledPercentage
  local matrixInPer = graph_data.matrix.ratio.getInputEnergyPercentage
  local matrixOutPer = graph_data.matrix.ratio.getOutputEnergyPercentage

  --- display matrix values
  local dp = 2
  local strMatrixMax = formatter.energy(matrixMax, dp, "FE")
  local strMatrixCur = formatter.energy(matrixCur, dp, "FE")
  local strMatrixPer = formatter.ratio(matrixTotPer, dp)

  --- total energy stored
  aligner.rightPrint(graph_coords.matrix[1].x0, graph_coords.matrix[1].x1, graph_coords.values.y0, strMatrixMax, graph_coords.matrix[1].color)
  aligner.rightPrint(graph_coords.matrix[1].x0, graph_coords.matrix[1].x1, graph_coords.values.y1, strMatrixCur, graph_coords.matrix[1].color)
  aligner.rightPrint(graph_coords.matrix[1].x0, graph_coords.matrix[1].x1, graph_coords.values.y2, strMatrixPer, graph_coords.matrix[1].color)

  --- input, output rate
  local strMatrixTransferCap = formatter.energy(matrixTransferCap, dp, "FE")
  local strMatrixInput = formatter.energy(matrixInput, dp, "FE")
  local strMatrixOutput = formatter.energy(matrixOutput, dp, "FE")
  local strMatrixInPer = formatter.ratio(matrixInPer, dp)
  local strMatrixOutPer = formatter.ratio(matrixOutPer, dp)

  aligner.rightPrint(graph_coords.matrix[2].x0, graph_coords.matrix[2].x1, graph_coords.values.y0, strMatrixTransferCap, graph_coords.matrix[2].color)
  aligner.rightPrint(graph_coords.matrix[2].x0, graph_coords.matrix[2].x1, graph_coords.values.y1, strMatrixInput, graph_coords.matrix[2].color)
  aligner.rightPrint(graph_coords.matrix[2].x0, graph_coords.matrix[2].x1, graph_coords.values.y2, strMatrixInPer, graph_coords.matrix[2].color)

  aligner.rightPrint(graph_coords.matrix[3].x0, graph_coords.matrix[3].x1, graph_coords.values.y0, strMatrixTransferCap, graph_coords.matrix[3].color)
  aligner.rightPrint(graph_coords.matrix[3].x0, graph_coords.matrix[3].x1, graph_coords.values.y1, strMatrixOutput, graph_coords.matrix[3].color)
  aligner.rightPrint(graph_coords.matrix[3].x0, graph_coords.matrix[3].x1, graph_coords.values.y2, strMatrixOutPer, graph_coords.matrix[3].color)


  -- redraw matrix empty bars
  for i = 1, #graph_coords.matrix do
    paintutils.drawFilledBox(graph_coords.matrix[i].x0+1, graph_coords.matrix[i].y0+1, graph_coords.matrix[i].x1-1, graph_coords.matrix[i].y1-1, colors.black)
  end
  reset_colors()

  -- draw matrix filled bars
  paintutils.drawFilledBox(graph_coords.matrix[1].x0, (1-matrixTotPer) * graph_coords.matrix[1].y1 + matrixTotPer * graph_coords.matrix[1].y0, 
  graph_coords.matrix[1].x1, graph_coords.matrix[1].y1, graph_coords.matrix[1].color)
  reset_colors()

  paintutils.drawFilledBox(graph_coords.matrix[2].x0, (1-matrixInPer) * graph_coords.matrix[2].y1 + matrixInPer * graph_coords.matrix[2].y0,
  graph_coords.matrix[2].x1, graph_coords.matrix[2].y1, graph_coords.matrix[2].color)
  reset_colors()

  paintutils.drawFilledBox(graph_coords.matrix[3].x0, (1-matrixOutPer) * graph_coords.matrix[3].y1 + matrixOutPer * graph_coords.matrix[3].y0,
  graph_coords.matrix[3].x1, graph_coords.matrix[2].y1, graph_coords.matrix[3].color)
  reset_colors()
  


  -- draw turbine bars
  local turbineMaxGen = graph_data.turbine.fe.getMaxProduction
  local turbineCurGen = graph_data.turbine.fe.getProductionRate

  local turbineMaxEnergy = graph_data.turbine.fe.getMaxEnergy
  local turbineCurEnergy = graph_data.turbine.fe.getEnergy

  local turbineMaxSteam = graph_data.turbine.fluid.getSteamCapacity
  local turbineCurSteam = graph_data.turbine.fluid.getSteam.amount

  local turbineGenPer = graph_data.turbine.ratio.getEnergyProductionPercentage
  local turbineEnergyPer = graph_data.turbine.ratio.getEnergyFilledPercentage
  local turbineSteamPer = graph_data.turbine.ratio.getSteamFilledPercentage

  -- display turbine values
  dp = 2

  local strTurbineMaxGen = formatter.energy(turbineMaxGen, dp, "FE")
  local strTurbineCurGen = formatter.energy(turbineCurGen, dp, "FE")
  local strTurbineGenPer = formatter.ratio(turbineGenPer, dp)

  local strTurbineMaxEnergy = formatter.energy(turbineMaxEnergy, dp, "FE")
  local strTurbineCurEnergy = formatter.energy(turbineCurEnergy, dp, "FE")
  local strTurbineEnergyPer = formatter.ratio(turbineEnergyPer, dp)

  local strTurbineMaxSteam = formatter.fluid(turbineMaxSteam, dp, "B")
  local strTurbineCurSteam = formatter.fluid(turbineCurSteam, dp, "B")
  local strTurbineSteamPer = formatter.ratio(turbineSteamPer, dp)

  aligner.rightPrint(graph_coords.turbine[1].x0, graph_coords.turbine[1].x1, graph_coords.values.y0, strTurbineMaxGen, graph_coords.turbine[1].color)
  aligner.rightPrint(graph_coords.turbine[1].x0, graph_coords.turbine[1].x1, graph_coords.values.y1, strTurbineCurGen, graph_coords.turbine[1].color)
  aligner.rightPrint(graph_coords.turbine[1].x0, graph_coords.turbine[1].x1, graph_coords.values.y2, strTurbineGenPer, graph_coords.turbine[1].color)

  -- redraw empty turbine bars
  for i=1, #graph_coords.turbine do
    paintutils.drawFilledBox(graph_coords.turbine[i].x0+1, graph_coords.turbine[i].y0+1, graph_coords.turbine[i].x1-1, graph_coords.turbine[i].y1-1, colors.black)
  end
  reset_colors()
  
  paintutils.drawFilledBox(graph_coords.turbine[1].x0, (1-turbineGenPer) * graph_coords.turbine[1].y1 + turbineGenPer * graph_coords.turbine[1].y0,
              graph_coords.turbine[1].x1, graph_coords.turbine[1].y1, graph_coords.turbine[1].color)
  reset_colors()

  aligner.rightPrint(graph_coords.turbine[2].x0, graph_coords.turbine[2].x1, graph_coords.values.y0, strTurbineMaxEnergy, graph_coords.turbine[2].color)
  aligner.rightPrint(graph_coords.turbine[2].x0, graph_coords.turbine[2].x1, graph_coords.values.y1, strTurbineCurEnergy, graph_coords.turbine[2].color)
  aligner.rightPrint(graph_coords.turbine[2].x0, graph_coords.turbine[2].x1, graph_coords.values.y2, strTurbineEnergyPer, graph_coords.turbine[2].color)
  paintutils.drawFilledBox(graph_coords.turbine[2].x0, (1-turbineEnergyPer) * graph_coords.turbine[2].y1 + turbineEnergyPer * graph_coords.turbine[2].y0,
              graph_coords.turbine[2].x1, graph_coords.turbine[2].y1, graph_coords.turbine[2].color)
  reset_colors()

  aligner.rightPrint(graph_coords.turbine[3].x0, graph_coords.turbine[3].x1, graph_coords.values.y0, strTurbineMaxSteam, graph_coords.turbine[3].color)
  aligner.rightPrint(graph_coords.turbine[3].x0, graph_coords.turbine[3].x1, graph_coords.values.y1, strTurbineCurSteam, graph_coords.turbine[3].color)
  aligner.rightPrint(graph_coords.turbine[3].x0, graph_coords.turbine[3].x1, graph_coords.values.y2, strTurbineSteamPer, graph_coords.turbine[3].color)
  paintutils.drawFilledBox(graph_coords.turbine[3].x0, (1-turbineSteamPer) * graph_coords.turbine[3].y1 + turbineSteamPer * graph_coords.turbine[3].y0,
  graph_coords.turbine[3].x1, graph_coords.turbine[3].y1, graph_coords.turbine[3].color)
  reset_colors()


  -- display switch, warn status

  local switchColors = {ON = {}, OFF = {}}
  switchColors.ON.t = {tColor = colors.white, bColor = colors.green}
  switchColors.ON.f = {tColor = colors.lightGray, bColor = colors.gray}
  switchColors.OFF.t = {tColor = colors.white, bColor = colors.red}
  switchColors.OFF.f = {tColor = colors.lightGray, bColor = colors.gray}


  -- display switch status
  for i = 1, #status_data.switch do
    -- selecting colors for ON/OFF switch
    if status_data.switch[i].enabled == true then 
      status_data.switch[i].colors.on = switchColors.ON.t
      status_data.switch[i].colors.off = switchColors.OFF.f
    else
      status_data.switch[i].colors.on = switchColors.ON.f
      status_data.switch[i].colors.off = switchColors.OFF.t
    end

    aligner.leftPrint(graph_coords.switch.x0, graph_coords.switch.x1-1, graph_coords.switch.y0 + i - 1, i .." " .. status_data.switch[i].name, colors.white)
    aligner.leftPrint(graph_coords.switch.x1, graph_coords.switch.x2-1, graph_coords.switch.y0 + i - 1, 
    " ON ", status_data.switch[i].colors.on.tColor, status_data.switch[i].colors.on.bColor)
    aligner.leftPrint(graph_coords.switch.x2, graph_coords.switch.x3-1, graph_coords.switch.y0 + i - 1,
     " OFF ", status_data.switch[i].colors.off.tColor, status_data.switch[i].colors.off.bColor)
    reset_colors()
  end
  

  -- display Warnings
  local warningColors = {
  enabled = {tColor = colors.yellow, bColor = colors.black, signColor = colors.yellow},
  disabled = {tColor = colors.lightGray, bColor = colors.black, signColor = colors.green}
  }
  
  for i = 1, #status_data.warning do
    local text, tColor, bColor, signColor
    if status_data.warning[i].enabled then
      text = status_data.warning[i].name.enabled
      tColor = warningColors.enabled.tColor
      bColor = warningColors.enabled.bColor
      signColor = warningColors.enabled.signColor
    else
      text = status_data.warning[i].name.disabled
      tColor = warningColors.disabled.tColor
      bColor = warningColors.disabled.bColor
      signColor = warningColors.disabled.signColor
    end
    local signChar = (status_data.warning[i].enabled) and "!" or "o"
    aligner.leftPrint(graph_coords.warning.x0, graph_coords.warning.x0, graph_coords.warning.y0 + i - 1, signChar, colors.black, signColor)
    aligner.leftPrint(graph_coords.warning.x0 + 2, graph_coords.warning.x1, graph_coords.warning.y0 + i - 1, text, tColor, bColor)
  end

  term.redirect(oldTerm)

end

return {update = update}