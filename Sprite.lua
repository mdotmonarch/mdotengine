-- mdotengine - sprite file

-- local definitions
local function makeQuad(xPos, quantity, width, height)
	return Graphics.newQuad(xPos, 0, width / quantity, height, width, height)
end

-- module creation
local Sprite = {}

function Sprite.new(spriteName, spriteType, filePath, quadNumber)
	local sprite = {
		isSprite = true,
		name = spriteName,
		type = spriteType,
		texture = Graphics.newImage(filePath)
	}
	if sprite.type == "2D" then
		return sprite
	elseif sprite.type == "3D" then
		local quadTable = {}
		local width = sprite.texture:getWidth()
		local height = sprite.texture:getHeight()
		for i = 1, quadNumber do
			local xDisplacement = (quadNumber - i) * width / quadNumber
			quadTable[i] = makeQuad(xDisplacement, quadNumber, width, height)
		end
		sprite.quadTable = quadTable
		return sprite
	else return nil end
end

return Sprite