-- mdotengine - setup file

-- Local definitions

local Setup = {}

local DebugEnvironment = require("DebugEnvironment")
local Camera = require("Camera")
local Scene = require("Scene")
local Debug = false
local logicPeriod = 1/60
local logicDt = 0

-- font setup
mainfont = Graphics.newFont("lib/res/m5x7.ttf", 16)
Graphics.setFont(mainfont)

-- world creation
local loadedScene = Scene:New()
loadedScene:Load("lib/level/env_test.html")

-- camera creation
local cam = Camera:New("cam01", 0, 0, Graphics.getWidth(), Graphics.getHeight())

function Setup.Draw()
	cam:Set()
	cam:Draw(loadedScene)
	cam:Unset()

	if Debug then
		DebugEnvironment:Draw(loadedScene, cam)
	end
end

function Setup.Update(dt)
	dt = Min(dt, logicPeriod)
	cam:Update(loadedScene, dt)
	logicDt = logicDt + dt
	if logicDt >= logicPeriod then
		loadedScene:Update(logicDt)
		logicDt = logicDt - logicPeriod
	end
end

function Setup.KeyPressed(key)
	cam:KeyPressed(key)
	if key == bindings.exit then
		Event.quit()
	end
	if key == bindings.debug then
		Debug = not Debug
	end
end 

function Setup.WheelMoved(x, y)
	cam:WheelMoved(x, y)
end

return Setup