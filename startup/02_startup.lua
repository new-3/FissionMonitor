require("/initenv").init_env()

sleep(2) -- wait until all multiblocks are activated

local start = require "main.main"
start.run()
