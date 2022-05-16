--- Simple colouring log formatter for (linux) terminal output.
-- Log levels are colourised fo reasier reading.
-- @usage
-- local log = lumber.new((require 'lumber.format.term'))

local colors = { "36", "31", "33", "32", "35" }

return function(level, input)
	local color = colors[level.index] or 0
	return string.format("\x1b[%im% 5s\x1b[0m %s", color, level.name, input:gsub("\n", string.format("\n    \x1b[%im↳\x1b[0m ", color)))
end
