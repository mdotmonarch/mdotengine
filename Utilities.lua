-- mdotengine - utilities file

--[[
	string methods.
]]--
function string.Split(str, delim)
	local substrs = {}
	for substr in str:gmatch(delim) do
		substrs[#substrs + 1] = substr
	end
	return substrs
end

function string.Clean(str)
	local newStr = ""
	for substr in str:gmatch("%S+") do
		newStr = newStr .. " " .. substr
	end
	return newStr:sub(2)
end

--[[
	generic utilities.
]]--

function Round(n, d)
	return math.floor(n * Pow(10, d)) / Pow(10, d)
end

