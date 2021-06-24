-- mdotengine - entity file

-- Local definitions
local Vector = require("Vector")

local function GetTypeFactor(sprite)
	return sprite.type == "3D" and #sprite.quadTable or 1
end

-- Module creation
local Entity = {}
Entity.__index = Entity

function Entity:New(s, x, y, r, seed)
	local attributes = {
		isEntity = true,
		isFixed = false,
		pos = Vector:New(x, y, nil, nil),
		rotationAngle = r,
		sprite = s,
		xMid = s.texture:getWidth() / GetTypeFactor(s) * .5,
		yMid = s.texture:getHeight() * .5
	}
	return setmetatable(attributes, self)
end

function Entity:AddAltSprite(token, sprite)
	self.altSprites[token] = sprite
end

function Entity:AlternateSprite(token)
	self.sprite = self.altSprites[token]
end

return Entity