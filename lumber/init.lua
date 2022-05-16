--- Simple and Modular logging library for Lua

local lumber = {}

local levels = {
	{ name = "FATAL" };
	{ name = "ERROR" };
	{ name = "WARN" };
	{ name = "INFO" };
	{ name = "DEBUG" };
}

lumber.levels = {}

local function combine(...)
	local input = {...}
	for index, value in ipairs(input) do
		if type(value) == "function" then
			input[index] = value()
		end
	end
	return table.concat(input, " ")
end

lumber.__index = lumber
lumber.__call = function(self, ...) return self:info(...) end

--- Creates a new logger object
-- @tparam function format A format function that formats the log message
-- @tparam io out An object with a `write` method to write output to
-- @tparam number level A number describing the output log level
function lumber.new(format, out, level)
	local format = format or require 'lumber.format.plain'
	local out = out or io.stderr
	local level = level or 3
	return setmetatable({ format = format, out = out, level = level }, lumber)
end

--- Lumber Logger
-- @type lumber

--- Logs a message with a given level
-- @tparam {index=number,name=string} level The level to which to log
-- @param message String or function that returns one
-- @param[opt] ... Further log messages
function lumber:log(level, ...)
	if not self.level then error("First argument is not a logger (calling with . instead of :?)", 2) end
	if self.level >= level.index then
		self.out:write(self.format(level, combine(...)))
		self.out:write("\n")
	end
end

--- Logs a message with fatal level
-- @function fatal
-- @param message String or function that returns one
-- @param[opt] ... Further log messages

--- Logs a message with error level
-- @function error
-- @param message String or function that returns one
-- @param[opt] ... Further log messages

--- Logs a message with warn level
-- @function warn
-- @param message String or function that returns one
-- @param[opt] ... Further log messages

--- Logs a message with info level
-- @function info
-- @param message String or function that returns one
-- @param[opt] ... Further log messages

--- Logs a message with debug level
-- @function debug
-- @param message String or function that returns one
-- @param[opt] ... Further log messages


for index, level in ipairs(levels) do
	lumber.levels[level.name] = index
	level.index = index
	lumber[level.name:lower()] = function(self, ...)
		if not self.level then error("First argument is not a logger (calling with . instead of :?)", 2) end
		return self:log(level, ...)
	end
end

return lumber
