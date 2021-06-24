-- mdotengine - bag file

-- Local definitions
local Bag = {}
Bag.__index = Bag
function Bag.__call(self, i) return self.content[self.current] end

function Bag:New()
	local attributes = {
		isBag = true,
		current = 0,
		content = {}
	}
	return setmetatable(attributes, self)
end

function Bag:Next()
	if self.current + 1 > #self.content then
		self.current = 1
	else 
		self.current = self.current + 1
	end
end

function Bag:Add(item)
	self.content[#self.content + 1] = item
	if #self.content == 1 then
		self.current = #self.content
	end
end

function Bag:Delete(index)
	if #self.content == 0 then
		return
	end
	self.content[index] = nil
	if self.current > #self.content then
		self.current = #self.content
	end
end

function Bag:Clean()
	local length = #self.content
	local translate = 0
	for index = 1, length do
	if self.content[index] ~= nil then
		translate = translate + 1
		self.content[translate] = self.content[index]
        end
	end
	for index = translate + 1, length do
        self.content[index] = nil
	end
end

function Bag:Remove(index)
	self:Delete(index)
	self:Clean()
end

return Bag