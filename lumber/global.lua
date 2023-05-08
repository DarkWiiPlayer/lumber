--- Provides an easy mechanism for managing a global logging element.
-- This module returns a callable object.
-- When called, it will set the global logger in the _G.logger variable to the passed argument.
-- When the passed argument does not have a metatable, it instead calls lumber.new to get the global logger.
-- Otherwise, the object mimics the logging functions of a logger and forwards them to the global logger object.
-- @usage
-- -- In your library code:
-- local log = require("lumber.global")
-- log:info("Log something, if there's a logger")
-- -- In a program using the library:
-- local log = require("lumber.global") {
-- 	format = require 'lumber.format.term';
-- 	level = 5;
-- }
-- log:debug("Setting global logger")

local lumber = require("lumber")

local meta = {}
local global = setmetatable({}, meta)

function meta:__call(logger)
	if logger then
		if not getmetatable(logger) then
			_G.logger = lumber.new(logger)
		else
			_G.logger = logger
		end
	end
	return self
end

for level, numeric in pairs(lumber.levels) do
	level = level:lower()
	global[level] = function(...)
		if _G.logger then
			if ... == global then
				return _G.logger[level](_G.logger, select(2, ...))
			else
				return _G.logger[level](_G.logger, ...)
			end
		end
	end
end

return global
