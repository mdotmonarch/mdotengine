-- mdotengine - main file

require("Settings")
require("Utilities")
Parser = require("Parser")
Parser:LoadFile("lib/level/env_test.html")

-- local variables
local Setup = require("Setup")

function love.load()
	love.filesystem.setIdentity("screenshot_example")
end

function love.draw()
	Setup.Draw()
end

function love.update(dt)
	Setup.Update(dt)
end

function love.keypressed(key)
	if key == "c" then
		love.graphics.captureScreenshot(os.time() .. ".png")
	end
	Setup.KeyPressed(key)
end

function love.wheelmoved(x, y)
	Setup.WheelMoved(x, y)
end
