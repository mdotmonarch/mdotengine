-- mdotengine - scene file

-- Local definitions
local ParticleEmitter = require("ParticleEmitter")
local Sprite = require("Sprite")
local Entity = require("Entity")
local Vector = require("Vector")
local Parser = require("Parser")

local function SortY(a, b)
	local ax = a.pos:GetX()
	local ay = a.pos:GetY()
	local bx = b.pos:GetX()
	local by = b.pos:GetY()
	local ayp = Sqrt(ax*ax + ay*ay) * Sin(Atg2(ay, ax))
	local byp = Sqrt(bx*bx + by*by) * Sin(Atg2(by, bx))
	return ayp < byp
end

-- Module creation
local Scene = {}
Scene.__index = Scene

function Scene:New()
	local attributes = {
		isLevel = true,
		xOrigin = 0,
		yOrigin = 0,
		title = "",
		cellSize = 0,
		sprites = {},
		entities2D = {},
		entities3D = {}
	}
	return setmetatable(attributes, self)
end

function Scene:Update(dt)
	for _, ent in ipairs(self.entities3D) do
		if ent.isParticleEmitter then
			ent:Update(dt)
		end
	end
end

function Scene:Load(path)
	local stateStack = {}
	for line in Filesystem.newFile(path):lines() do
		tokens = line:Split("%S+")
		for _, token in ipairs(tokens) do
			if 	Parser:IsStartNode(token) then
				table.insert(stateStack, Parser:GetNodeTag(token))
			elseif Parser:IsEndNode(token) then
				if Parser:GetNodeTag(token) == stateStack[#stateStack] then
					stateStack[#stateStack] = nil
				end
			else
				local state = stateStack[#stateStack]
				if state == "title" then
					self:SetTitle(token:Clean())
				elseif state == "cellSize" then
					self:SetCellSize(tonumber(token:Clean()))
				elseif state == "sprites" then
					self:AddSprite(token:Split("[^;]+"))
				elseif state == "entities" then
					self:AddEntity(token:Split("[^;]+"))
				elseif state == "altSprites" then
					self:AddAltSpriteToEntity(token:Clean())
				elseif state == "matrix" then
					self:AddEntityMatrix(token:Split("[^;]+"))
				elseif state == "backColor" then
					self:SetBackgroundColor(token:Split("[^;]+"))
				elseif state == "particleEmitter" then
					self:AddParticleEmitter(token:Split("[^;]+"))
				end
			end
		end
	end
	table.sort(self.entities3D, SortY)
end

function Scene:SetTitle(str)
	self.title = str
end

function Scene:SetCellSize(num)
	self.cellSize = num
end

function Scene:TransformOrigin(cam, dt)
	local xPos = self.xOrigin - cam.pos:GetX()
	local yPos = self.yOrigin - cam.pos:GetY()
	local radius = Sqrt(xPos*xPos + yPos*yPos)
	local angle = Atg2(yPos, xPos)
	if angle > 2*Pi then
		angle = angle - (2 * Pi)
	end
	angle = angle + (cam.rVel * dt)	
	self.xOrigin = radius * Cos(angle) + cam.pos:GetX()
	self.yOrigin = radius * Sin(angle) + cam.pos:GetY()
end

function Scene:SetBackgroundColor(args)
	local r = tonumber(args[1]) / 255
	local g = tonumber(args[2]) / 255
	local b = tonumber(args[3]) / 255
	Graphics.setBackgroundColor(r, g, b)
end

function Scene:AddSprite(args)
	local type = args[1]
	local token = args[2]
	local path = args[3]
	local layq = tonumber(args[4])
	self.sprites[token] = Sprite.new(token, type, path, layq)
end

function Scene:AppendEntity(sprite, xPos, yPos, rPos)
	if sprite.type == "2D" then
		table.insert(self.entities2D, Entity:New(sprite, xPos, yPos, rPos))
	elseif sprite.type == "3D" then
		table.insert(self.entities3D, Entity:New(sprite, xPos, yPos, rPos))
	end
	lastAdded = sprite.type
end

function Scene:AddEntity(args)
	local sprite = self.sprites[args[1]]
	local xPos = tonumber(args[2]) * self.cellSize
	local yPos = tonumber(args[3]) * self.cellSize
	local rPos = Rad(tonumber(args[4]))
	self:AppendEntity(sprite, xPos, yPos, rPos)
end

function Scene:AddParticleEmitter(args)
	local x = tonumber(args[2]) * self.cellSize
	local y = tonumber(args[3]) * self.cellSize
	local rc = tonumber(args[4]) / 255
	local gc = tonumber(args[5]) / 255
	local bc = tonumber(args[6]) / 255
	local c = {rc, gc, bc}
	local b = {}
	local r = 0
	local f = 0
	local l = 0
	if args[1] == "smoke" then
		r = 0
		f = .1
		l = 100
		b.x = function(p, t) return p + 0.3 * Sin(Random(0, 2 * Pi)) end
		b.y = function(p, t) return p + 0.3 * Sin(Random(0, 2 * Pi)) end
		b.z = function(t) return -16 * t * t end
		b.r = function(p, t) return 7 + Exp(t * 0.4) end
	elseif args[1] == "fire" then
		r = 2
		f = .1
		l = 15
		b.x = function(p, t) return p + Sin(Random(0, 2 * Pi)) end
		b.y = function(p, t) return p + Sin(Random(0, 2 * Pi)) end
		b.z = function(t) return -(5 * Pow(t, 3)) end
		b.r = function(p, t) return -t end
	elseif args[1] == "bubble" then
		r = 1
		f = .5
		l = 10
		b.x = function(p, t) return 0 end
		b.y = function(p, t) return 0 end
		b.z = function(t) return -(55 + 10 * Log(t)) end
		b.r = function(p, t) return t * .8 end
	elseif args[1] == "sine" then
		r = 0
		f = .01
		l = 100
		b.x = function(p, t) return 10*Sin(8*t) end
		b.y = function(p, t) return 10*Sin(8*t) end
		b.z = function(t) return -60 * t end
		b.r = function(p, t) return 1 end
	elseif args[1] == "cosine" then
		r = 0
		f = .01
		l = 100
		b.x = function(p, t) return 10*Cos(8*t) end
		b.y = function(p, t) return 10*Cos(8*t) end
		b.z = function(t) return -60 * t end
		b.r = function(p, t) return 1 end
	end
	table.insert(self.entities3D, ParticleEmitter:New(x, y, r, f, l, c, b))
end

function Scene:AddEntityMatrix(args)
	local sprite = self.sprites[args[1]]
	local rows = tonumber(args[2])
	local cols = tonumber(args[3])
	local xFrom = tonumber(args[4])
	local yFrom = tonumber(args[5])
	local rPos = Rad(tonumber(args[6]))
	for i = yFrom, yFrom + rows - 1 do
		yPos = i * self.cellSize
		for j = xFrom, xFrom + cols - 1 do
			xPos = j * self.cellSize
			self:AppendEntity(sprite, xPos, yPos, rPos)
		end
	end
end

return Scene