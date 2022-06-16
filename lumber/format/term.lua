--- Simple colouring log formatter for (linux) terminal output.
-- Log levels are colourised fo reasier reading.
-- @usage
-- local log = lumber.new((require 'lumber.format.term'))

local colors = { "36", "31", "33", "32", "35" }

return function(level, input, context)
	local color = colors[level.index] or 0
	prefix = context and ("["..context .. "] ") or ""
	return string.format("\x1b[2m%s%s \x1b[%im% 5s \x1b[0m%s", prefix, os.date("%H:%M:%S"), color, level.name, input:gsub("\n", string.format("\n" .. string.rep(" ", #prefix + 13) .. "\x1b[%im↳\x1b[0m ", color)))
end
