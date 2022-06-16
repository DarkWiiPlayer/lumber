--- Simple and Modular logging library for Lua.
-- This is the core module of Lumber where most of the magic happens here.

local lumber = {}

local levels = {
	{ name = "FATAL" };
	{ name = "ERROR" };
	{ name = "WARN" };
	{ name = "INFO" };
	{ name = "DEBUG" };
}

lumber.levels = {}

local function combine(logger, ...)
	local input = {...}
	for index, value in ipairs(input) do
		if type(value) == "function" then
			input[index] = combine(logger, value())
		else
			input[index] = logger.filter(input[index])
		end
	end
	return table.concat(input, logger.separator)
end

lumber.__index = lumber
lumber.__call = function(self, ...) return self:info(...) end

--- Creates a new logger object.
-- When an options table is passed in, it is returned after assigning it a new metatable.
-- @tparam[opt={}] table options A table with options for the logger
-- @return A new logger object.
-- @usage
-- local lumber = require 'lumber'
-- local log = lumber.new {
-- 	level = 5;
-- 	out = io.stderr;
-- 	-- etc.
-- }
function lumber.new(logger)
	logger = logger or {}
	return setmetatable(logger, lumber)
end

--- Options.
-- Each of these options can be set for every logger object.
-- They can also be overridden globally by modifying the defaults
-- in the `lumber` table directly, but this is not recommended.
-- @section options

--- Formatter function.
-- This function receives the log level
-- and the concatenated log message as a
-- string and should return the final string
-- that is written to the output object.
lumber.format = require 'lumber.format.plain'
--- IO object to write output to.
-- This must be an object with a `write` method,
-- but otherwise doesn't have to be an actual IO
-- object.
lumber.out = io.stderr
--- Log level.
-- Everything logged with a higher level than this
-- will be ignored.
lumber.level = 3
-- Separator for concatenating multiple values.
-- When more than one value is passed to a log function,
-- the values are concatenated with this string
-- in between.
lumber.separator = " "
--- Filter function for non-function values.
lumber.filter = tostring
--- Function that returns additional context.
-- Formatters may decide what to do with this data, or to discard it entirely.
-- This could be a thread id, a file name, etc.
lumber.context = nil

--- The actual logger object which does the logging.
-- @type Logger
-- @usage
--
-- local log = lumber.new {
-- 	level = 3 
-- }
-- log:info("Something happened")
-- log.level = 2 -- Options can be changed later on

--- Logs a message with a given level
-- @tparam {index=number,name=string} level The level to which to log
-- @param message String or function that returns one
-- @param[opt] ... Further log messages
function lumber:log(level, ...)
	if not self.level then error("First argument is not a logger (calling with . instead of :?)", 2) end
	if self.level >= level.index then
		self.out:write(self.format(level, combine(self, ...), self.context and self.context()))
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
