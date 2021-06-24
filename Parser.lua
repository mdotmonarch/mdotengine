-- mdotengine - parser file

-- Local definitions
local Parser = {}

function Parser.IsNode(str)
	return str:sub(str:len(), str:len()) == ">" and str:sub(1, 1) == "<"
end

function Parser:IsEndNode(str)
	return self.IsNode(str) and str:sub(2, 2) == "/"
end

function Parser:IsStartNode(str)
	return self.IsNode(str) and str:sub(2, 2) ~= "/"
end

function Parser:GetNodeTag(node)
	if self:IsStartNode(node) then
		return node:sub(2, node:len() - 1)
	elseif self:IsEndNode(node) then
		return node:sub(3, node:len() - 1)
	else return nil
	end
end

function Parser:LoadFile(path)
    local stateStack = {}
	for line in Filesystem.newFile(path):lines() do
		tokens = line:Split("%S+")
		for _, token in ipairs(tokens) do
			if self:IsStartNode(token) then
                table.insert(stateStack, self:GetNodeTag(token))
			elseif self:IsEndNode(token) then
				if self:GetNodeTag(token) == stateStack[#stateStack] then
					stateStack[#stateStack] = nil
				end
			else
				local state = stateStack[#stateStack]
			end
		end
	end
end

return Parser
