-- mdotengine - particle emitter file

-- Local definitions
local Particle = require("Particle")
local Vector = require("Vector")
local Bag = require("Bag")

local ParticleEmitter = {}
ParticleEmitter.__index = ParticleEmitter

function ParticleEmitter:New(x, y, r, f, l, c, b)
	local attributes = {
		isParticleEmitter = true,
		bag = Bag:New(),
		pos = Vector:New(x, y, nil, nil),
		frequency = f,
		rad = r,
		limit = l,
		color = c,
		behaviour = b,
		delta = 0
	}
	return setmetatable(attributes, self)
end

function ParticleEmitter:Update(dt)
	if self.delta > self.frequency then
		self.bag:Add(Particle:New(self.pos:GetX(), self.pos:GetY(), self.rad))
		if #self.bag.content > self.limit then
			self.bag:Remove(1)
		end
		self.delta = self.delta - self.frequency
	end
	
	for i = 1, #self.bag.content do
		self.bag.content[i]:Update(self.behaviour, dt)
	end
	
	self.delta = self.delta + dt
end

return ParticleEmitter