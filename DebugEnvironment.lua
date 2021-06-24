local DebugEnvironment = {}

function DebugEnvironment:Draw(lvl, cam)
	local rx = cam.pos:GetX() - lvl.xOrigin
	local ry = cam.pos:GetY() - lvl.yOrigin
	local norm = Sqrt((rx*rx) + (ry*ry), 2)
	local angle = Atg2(ry, rx)
	angle = angle - cam.angle
	
	local CamX = Round(norm * Cos(angle), 2)
	local CamY = Round(norm * Sin(angle), 2)
	local CamR = Round(cam.angle * 180 / Pi, 2)
	local CamS = cam.scale

	local statlist = {
		"FPS : "..Timer.getFPS(),
		"Name: "..lvl.title,
		"CamX: "..CamX,
		"CamY: "..CamY,
		"CamR: "..CamR.."º",
		"CamS: "..CamS,
		"RVel: "..Round(cam.rVel, 2)
	}

	Graphics.setColor(0, 0, 0, .5)
	Graphics.rectangle("fill", 0, 0, 250, Graphics.getHeight())

	Graphics.setColor(1, 1, 1)
	for index, stat in ipairs(statlist) do
		Graphics.print(stat, 4, (index - 1) * 10)
	end
end

function DebugEnvironment:KeyPressed(key)
end

return DebugEnvironment