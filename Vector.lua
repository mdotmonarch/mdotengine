local Vector = {}
Vector.__index = Vector

function Vector:New(xPos, yPos)
	local attributes = {
		isVector = true,
		x = xPos,
		y = yPos
	}
	return setmetatable(attributes, self)
end

function Vector:GetX() return self.x end
function Vector:SetX(xPos) self.x = xPos end

function Vector:GetY() return self.y end
function Vector:SetY(yPos) self.y = yPos end

return Vector