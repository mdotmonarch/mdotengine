-- mdotengine - particle file

-- Local definitions
local Vector = require("Vector")

local Particle = {}
Particle.__index = Particle

function Particle:New(x, y, r, l)
	local attributes = {
		isParticle = true,                                                       -- identifier
		pos = Vector:New(x, y),                                                  -- vector position
		pre = Vector:New(0, 0),                                                  -- previous vector position
		radius = r,                                                              -- particle's radius
		dtime = 0                                                                -- time passed since spawned
	}
	return setmetatable(attributes, self)
end

function Particle:Update(behaviour, dt)
	self.pos:SetX(behaviour.x(self.pre:GetX(), self.dtime))
	self.pos:SetY(behaviour.y(self.pre:GetY(), self.dtime))
	self.radius = behaviour.r(self.radius, self.dtime)
	self.pre:SetX(self.pos:GetX())
	self.pre:SetY(self.pos:GetY())
	self.dtime = self.dtime + dt
end

return Particle
