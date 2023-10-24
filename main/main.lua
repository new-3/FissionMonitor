
require("/initenv").init_env()

local init = require "monitor.initialize"

local reader = require "main.statsReader"
local displayer = require "main.statsUpdater"
local control = require "main.switchController"

local export = require "util.exportTable"


sleep(2) -- wait until all multiblocks are activated

-- config
local isWrite = true -- export tables into text files if true
local updatePeriod = 1000 -- milliseconds

local graph_coords = init.init()

local function loop()
  local graph_data = reader.read()
  local status_data = control.eval(graph_data)

  -- export files to text files, only Once
  if isWrite then
    export.write(graph_coords, "coord")
    export.write(graph_data, "values")
    export.write(status_data, "status")
  end
  isWrite = false
  local display = displayer.update(graph_coords, graph_data, status_data)
  sleep(updatePeriod/1000)
end


function run()
  local count = 0

  while true do
    loop()
    term.clear()
    term.setCursorPos(1,1)
    print("Running for " .. count .. " seconds..")
    count = count + 1
  end
end

return {run = run}