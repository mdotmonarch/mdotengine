-- mdotengine - camera file

-- local definitions

local Vector = require("Vector")
local Bag = require("Bag")

local function GetInFrameFactor(entity)
	return entity.sprite.type == "3D" and #entity.sprite.quadTable or 1
end

local sortAngle = 0

local function SortY(a, b)
	local ax = a.pos:GetX()
	local ay = a.pos:GetY()
	local bx = b.pos:GetX()
	local by = b.pos:GetY()
	local ayp = Sqrt(ax*ax + ay*ay) * Sin(sortAngle + Atg2(ay, ax))
	local byp = Sqrt(bx*bx + by*by) * Sin(sortAngle + Atg2(by, bx))
	return ayp < byp
end

local Camera = {}
Camera.__index = Camera
Camera.bag = Bag:New()

function Camera:New(n, x, y, w, h)
	local attributes = {
		pos = Vector:New(x, y),
		isCamera = true,
		isXMoving = false,
		isYMoving = false,
		isRMoving = false,
		showPointer = false,
		showOrigin = false,
		showConsole = false,
		height = h,
		width = w,
		speed = 1000,
		scale = 1,
		drag = 1.5,
		angle = 0,
		name = n,
		xDir = 0,
		yDir = 0,
		rDir = 0,
		xVel = 0,
		yVel = 0,
		rVel = 0,
		rVelMax = 8
	}
	return setmetatable(attributes, self)
end

function Camera:Set()
	Graphics.push()
	local x = (.5 * Graphics.getWidth()) - self.pos:GetX()
	local y = (.5 * Graphics.getHeight()) - self.pos:GetY()
	Graphics.translate(x, y)
end

function Camera:Scale()
	local x = self.pos:GetX()
	local y = self.pos:GetY()
	Graphics.translate(x, y)
	Graphics.scale(self.scale, self.scale)
	Graphics.translate(-x, -y)
end

function Camera:Descale()
	local x = self.pos:GetX()
	local y = self.pos:GetY()
	Graphics.translate(x, y)
	Graphics.scale(1/self.scale, 1/self.scale)
	Graphics.translate(-x, -y)
end

function Camera:Unset()
	Graphics.pop()
end

function Camera:Control()	
	if Keyboard.isDown(bindings.cam.left) then
		self.isXMoving = true
		self.xDir = -1
	elseif Keyboard.isDown(bindings.cam.right) then
		self.isXMoving = true
		self.xDir = 1
	else
		self.isXMoving = false
	end

	if Keyboard.isDown(bindings.cam.up) then
		self.isYMoving = true
		self.yDir = -1
	elseif Keyboard.isDown(bindings.cam.down) then
		self.isYMoving = true
		self.yDir = 1
	else
		self.isYMoving = false
	end

	if Keyboard.isDown(bindings.cam.rotateCW) then
		self.isRMoving = true
		self.rDir = 1
	elseif Keyboard.isDown(bindings.cam.rotateCCW) then
		self.isRMoving = true
		self.rDir = -1
	else
		self.isRMoving = false
	end

	if Keyboard.isDown(bindings.cam.stop) then
		self.xVel = 0
		self.yVel = 0
		self.rVel = 0
	end	
	
end

function Camera:Move(dt)
	if self.isXMoving then
		if self.xVel > -self.speed or self.xVel < self.speed then
			self.xVel = self.xVel + (self.speed * self.xDir * dt)
		end
	end

	if self.isYMoving then
		if self.yVel > -self.speed or self.yVel < self.speed then
			self.yVel = self.yVel + (self.speed * self.yDir * dt)
		end
	end

	self.xVel = self.xVel * (1 - Min(self.drag * dt, 1))
	self.yVel = self.yVel * (1 - Min(self.drag * dt, 1))

	self.pos:SetX(self.pos:GetX() + (self.xVel * dt))
	self.pos:SetY(self.pos:GetY() + (self.yVel * dt))
end

function Camera:Rotate(dt)
	if self.isRMoving then
		if self.rVel > -self.rVelMax or self.rVel < self.rVelMax then
			self.rVel = self.rVel + (self.rVelMax * self.rDir * dt)
		end
	end
	self.rVel = self.rVel * (1 - Min(self.drag * dt, 1))
	self.angle = self.angle + (self.rVel * dt)
	if self.angle > 2 * Pi then
		self.angle = self.angle - (2 * Pi)
	elseif self.angle < 0 then
		self.angle = self.angle + (2 * Pi)
	end
end

function Camera:OriginRotation(x, y)
	local radius = Sqrt(x*x + y*y)
	local angle = Atg2(y, x)
	local r = self.angle
	return radius * Cos(r + angle), radius * Sin(r + angle)
end

function Camera:Update(scn, dt)
	self:Control()
	self:Move(dt)
	self:Rotate(dt)

	sortAngle = self.angle
	table.sort(scn.entities3D, SortY)
	
	scn:TransformOrigin(self, dt)
end

function Camera:DrawEntity2D(ent)
	local x, y = self:OriginRotation(ent.pos:GetX(), ent.pos:GetY())
	local r = self.angle + ent.rotationAngle
	Graphics.draw(ent.sprite.texture, x, y, r, 1, 1, ent.xMid, ent.yMid)
end

function Camera:DrawEntity3D(ent)
	local x, y = self:OriginRotation(ent.pos:GetX(), ent.pos:GetY())
	local r = self.angle + ent.rotationAngle
	for i, q in ipairs(ent.sprite.quadTable) do
		local yR = y - i
		Graphics.draw(ent.sprite.texture, q, x, yR, r, 1, 1, ent.xMid, ent.yMid)
	end
end

function Camera:DrawParticle(ptc, pos, behaviour, color)
	local ex, ey = pos:GetX(), pos:GetY()
	local px, py = self:OriginRotation(ptc.pos:GetX() + ex, ptc.pos:GetY() + ey)
	local r, g, b = unpack(color)
	py = py + behaviour.z(ptc.dtime)
	Graphics.setColor(r, g, b)
	Graphics.circle('fill', px, py, ptc.radius)
	Graphics.setColor(1, 1, 1)
end

function Camera:DrawParticles(emr, lvl)
	local x, y = self:OriginRotation(emr.pos:GetX(), emr.pos:GetY())
	for i = 1, #emr.bag.content do
		self:DrawParticle(emr.bag.content[i], emr.pos, emr.behaviour, emr.color)
	end
end

function Camera:DrawEntities(scn)
	Graphics.push()
	Graphics.translate(scn.xOrigin, scn.yOrigin)
	for _, ent in ipairs(scn.entities2D) do
		self:DrawEntity2D(ent, scn)
	end
	for _, ent in ipairs(scn.entities3D) do
		if ent.isParticleEmitter then
			self:DrawParticles(ent, scn)
		end
	end
	for _, ent in ipairs(scn.entities3D) do
		if ent.isEntity then
			self:DrawEntity3D(ent, scn)
		end
	end
	Graphics.pop()
end

function Camera:Draw(lvl)
	Graphics.setColor(1, 1, 1)
	self:Scale()
	self:DrawEntities(lvl)
	if self.showOrigin then
		Graphics.setColor(1, 0, 0)
		Graphics.points(lvl.xOrigin, lvl.yOrigin)
		Graphics.setColor(1, 1, 1)
	end
	self:Descale()
	if self.showPointer then
		local xCam = self.pos:GetX()
		local yCam = self.pos:GetY()
		Graphics.setColor(1, 1, 1)
		Graphics.line(xCam, yCam - 5, xCam, yCam + 5)
		Graphics.line(xCam - 5, yCam, xCam + 5, yCam)
	end
end

function Camera:KeyPressed(key)
	if key == "tab" then
		self.showStats = not self.showStats
		self.showOrigin = not self.showOrigin
		self.showPointer = not self.showPointer
	end
end

function Camera:WheelMoved(x, y)
	self.scale = self.scale + (y * .1)
	if self.scale < .5 then
		self.scale = 0.5
	end
	if self.scale > 8 then
		self.scale = 8
	end
end

return Camera