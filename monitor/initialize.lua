local mon = peripheral.wrap("monitor_1")

local aligner = require("libs.textAlign")
local reset_colors = require("libs.mon_control").reset

-- draw background chart
function init()
  mon.setTextScale(0.5)
  oldTerm = term.redirect(mon)
  reset_colors()
  term.clear()

  local globalWidth, globalHeight = mon.getSize() -- 100 52 (4x5 monitors)

  local chartColors = {
    frame = colors.lightGray,
    turbine = colors.cyan,
    default_text = colors.white
  }

  -- draw matrix frame, located at left upper corner of the screen
  local matrix_frame_cfg = {
    margin_left = 5, margin_up = 2,
    width = 51, height = 38,
    x1 = nil,
    y1 = nil
  }

  matrix_frame_cfg.x0 = matrix_frame_cfg.margin_left + 1
  matrix_frame_cfg.y0 = matrix_frame_cfg.margin_up + 1

  matrix_frame_cfg.x1 = matrix_frame_cfg.x0 + matrix_frame_cfg.width + 1
  matrix_frame_cfg.y1 = matrix_frame_cfg.y0 + matrix_frame_cfg.height + 1

  paintutils.drawBox(matrix_frame_cfg.x0, matrix_frame_cfg.y0, matrix_frame_cfg.x1, matrix_frame_cfg.y1, chartColors.frame)
  reset_colors()
  aligner.centeredPrint(matrix_frame_cfg.x0+1, matrix_frame_cfg.x1-1, matrix_frame_cfg.y0+2, "INDUCTION MATRIX", chartColors.default_text)

  -- matrix bar configs 

  local _matrix_bars = {"TOTAL", "INPUT", "OUTPUT"}
  local _matrix_colors = {colors.green, colors.lightBlue, colors.red}
  local matrix_coord = {}

  local matrix_common_cfg = {
    width = nil, height = nil,
    margin_x_side = 5,
    margin_x_mid = 1, margin_y_up = 5, margin_y_down = 5
  }

  -- calculate width and height of matrix bars using designated margin values
  matrix_common_cfg.width = math.floor((matrix_frame_cfg.width - (2 * matrix_common_cfg.margin_x_side + #_matrix_bars * matrix_common_cfg.margin_x_mid)) / #_matrix_bars) - 2
  matrix_common_cfg.height = matrix_frame_cfg.height - matrix_common_cfg.margin_y_up - matrix_common_cfg.margin_y_down - 2


  -- draw matrix bars
  for i = 1, #_matrix_bars do
    local x0 = matrix_frame_cfg.x0 + matrix_common_cfg.margin_x_side + 1 + (i-1) * (matrix_common_cfg.margin_x_mid + 1) + (i-1) * (matrix_common_cfg.width + 2)
    local y0 = matrix_frame_cfg.y0 + matrix_common_cfg.margin_y_up + 1
    local x1 = x0 + matrix_common_cfg.width + 1
    local y1 = y0 + matrix_common_cfg.height + 1
    local color = _matrix_colors[i]
    local title = _matrix_bars[i]
    matrix_coord[i] = {x0=x0, y0=y0, x1=x1, y1=y1, color = color, title = title}

    aligner.centeredPrint(x0, x1, y0-2, title, color)
    paintutils.drawBox(x0, y0, x1, y1, color)
    reset_colors()
  end

  ------------------------------
  -- draw turbine frame, located at right upper corner of the screen
  local turbine_frame_cfg = {
    margin_right = 5, margin_up = 2,
    x0 = matrix_frame_cfg.x1,
    y0 = nil,
    x1 = nil,
    y1 = matrix_frame_cfg.y1,
    width = nil, height = nil
  }

  turbine_frame_cfg.x1 = globalWidth - turbine_frame_cfg.margin_right
  turbine_frame_cfg.y0 = turbine_frame_cfg.margin_up + 1

  turbine_frame_cfg.width = turbine_frame_cfg.x1 - turbine_frame_cfg.x0 - 1
  turbine_frame_cfg.height = turbine_frame_cfg.y1 - turbine_frame_cfg.y0 - 1

  aligner.centeredPrint(turbine_frame_cfg.x0+1, turbine_frame_cfg.x1-1, turbine_frame_cfg.y0+2, "TURBINE", chartColors.default_text)
  paintutils.drawBox(turbine_frame_cfg.x0, turbine_frame_cfg.y0, turbine_frame_cfg.x1, turbine_frame_cfg.y1, chartColors.frame)
  reset_colors()

  -- draw turbine bars

  local _turbine_bars = {"Enrgy Gen", "Energy", "Steam"}
  local _turbine_colors = {colors.lime, colors.green, colors.cyan}
  local turbine_coord = {} -- included in the return table

  local turbine_common_cfg = {
    width = nil, height = nil,
    margin_x_side = 2,
    margin_x_mid = 1, margin_y_up = 5, margin_y_down = 5
  }

  turbine_common_cfg.width = math.floor((turbine_frame_cfg.width - (2 * turbine_common_cfg.margin_x_side + #_turbine_bars * turbine_common_cfg.margin_x_mid)) / #_turbine_bars) - 2
  turbine_common_cfg.height = turbine_frame_cfg.height - turbine_common_cfg.margin_y_up - turbine_common_cfg.margin_y_down - 2


  for i = 1, #_turbine_bars do
    local x0 = turbine_frame_cfg.x0 + turbine_common_cfg.margin_x_side + 1 + (i-1) * (turbine_common_cfg.margin_x_mid + 1) + (i-1) * (turbine_common_cfg.width + 2)
    local y0 = turbine_frame_cfg.y0 + turbine_common_cfg.margin_y_up + 1
    local x1 = x0 + turbine_common_cfg.width + 1
    local y1 = y0 + turbine_common_cfg.height + 1
    local color = _turbine_colors[i]
    local title = _turbine_bars[i]
    turbine_coord[i] = {x0=x0, y0=y0, x1=x1, y1=y1, color = color, title = title}

    aligner.centeredPrint(x0, x1, y0-2, title, color)
    paintutils.drawBox(x0, y0, x1, y1, color)
    reset_colors()
  end


  local values_cfg = {
    y0 = matrix_coord[1].y1 + 2,
    y1 = matrix_coord[1].y1 + 3,
    y2 = matrix_coord[1].y1 + 4
  }

  -- energy display area
  
  aligner.centeredPrint(matrix_frame_cfg.x0 + 2, matrix_frame_cfg.x0 + 4, values_cfg.y0, "MAX")
  aligner.centeredPrint(matrix_frame_cfg.x0 + 2, matrix_frame_cfg.x0 + 4, values_cfg.y1, "CUR")
  aligner.centeredPrint(matrix_frame_cfg.x0 + 2, matrix_frame_cfg.x0 + 4, values_cfg.y2, "%")

  -- display heater switch status

  local switch_frame = {
    x0 = matrix_frame_cfg.x0,
    y0 = matrix_frame_cfg.y1,
    x1 = matrix_frame_cfg.x1,
    y1 = matrix_frame_cfg.y1 + 8
  }

  -- switch display cfg (text)

  local switch_cfg = {
    x0 = switch_frame.x0 + 2,
    label_width = 17,
    on_width = 4,
    off_width = 5,
    x1 = nil, x2 = nil, x3 = nil,
    y0 = switch_frame.y0 + 4,
    y1 = switch_frame.y0 + 5
  }
  switch_cfg.x1 = switch_cfg.x0 + switch_cfg.label_width
  switch_cfg.x2 = switch_cfg.x1 + switch_cfg.on_width
  switch_cfg.x3 = switch_cfg.x2 + switch_cfg.off_width


  paintutils.drawBox(switch_frame.x0, switch_frame.y0, switch_frame.x1, switch_frame.y1, chartColors.frame)
  reset_colors()

  -- display switch label
  aligner.leftPrint(switch_cfg.x0, switch_frame.x1, switch_frame.y0 + 2, "Heater Switch Status", chartColors.default_text)


  -- display Warning status
  -- Warning frame
  local warning_frame = {
    x0 = switch_frame.x1,
    y0 = switch_frame.y0,
    x1 = turbine_frame_cfg.x1,
    y1 = switch_frame.y1
  }
warning_frame.width = warning_frame.x1 - warning_frame.x0 - 1
  paintutils.drawBox(warning_frame.x0, warning_frame.y0, warning_frame.x1, warning_frame.y1, chartColors.frame)
  reset_colors()
  -- display warning label
  local warning_cfg = {
    x0 = warning_frame.x0 + 2,
    x1 = warning_frame.x1 - 1,
    y0 = warning_frame.y0 + 4
  }



  aligner.leftPrint(warning_cfg.x0, warning_frame.x1-1, warning_cfg.y0 - 2, "Warning Status", chartColors.default_text)

  

  -- end, redirect to computer terminal
  term.redirect(oldTerm)

  -- return value of the function
  -- will be used in dynamic chart drawer
  local bar_coords = {matrix = matrix_coord, turbine = turbine_coord, values = values_cfg, switch = switch_cfg, warning = warning_cfg}
  
-- testing values 
  --[[
  local real_margin_x_right = matrix_frame_cfg.x1 - matrix_coord[3].x1 - 1
  print(("%d %d %d"):format(matrix_frame_cfg.x1, matrix_coord[3].x1, real_margin_x_right))

  local real_margin_x_left = matrix_coord[1].x0 - matrix_frame_cfg.x0 - 1
  print("Left Margin X: " .. real_margin_x_left)
  print("Right Margin X: " .. real_margin_x_right)
  --]]
  return bar_coords





end

function drawEmptyBars()
  
end

return {init = init, resetBars = drawEmptyBars}

