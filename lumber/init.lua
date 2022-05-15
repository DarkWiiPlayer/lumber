local lumber = {}

local levels = {
	{ name = "FATAL" };
	{ name = "ERROR" };
	{ name = "WARN" };
	{ name = "INFO" };
	{ name = "DEBUG" };
}

lumber.levels = {}

for index, level in ipairs(levels) do
	lumber.levels[level.name] = index
	level.index = index
	lumber[level.name:lower()] = function(self, ...)
		if not self.level then error("First argument is not a logger (calling with . instead of :?)", 2) end
		return self:log(level, ...)
	end
end

local function combine(...)
	local input = {...}
	for index, value in ipairs(input) do
		if type(value) == "function" then
			input[index] = value()
		end
	end
	return table.concat(input, " ")
end

function lumber:log(level, ...)
	if not self.level then error("First argument is not a logger (calling with . instead of :?)", 2) end
	if self.level >= level.index then
		self.out:write(self.format(level, combine(...)))
		self.out:write("\n")
	end
end

lumber.__index = lumber
lumber.__call = function(self, ...) return self:info(...) end

function lumber.new(format, out, level)
	local format = format or require 'lumber.format.plain'
	local out = out or io.stderr
	local level = level or 3
	return setmetatable({ format = format, out = out, level = level }, lumber)
end

return lumber
