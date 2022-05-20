--- Simple log formatter for file output.
-- Writes messages as `YYYY-MM-DD HH:MM:SS +0000 [LEVEL] file:line -- log message`.
-- @usage
-- local log = lumber.new((require 'lumber.format.file'))

local function file_line(x)
	local info = debug.getinfo(x+1)
	return info.short_src..":"..info.currentline
end

return function(level, input)
	return string.format("%s [%s] %s -- %s", os.date("%Y-%m-%d %H:%M:%S %z"), level.name, file_line(3), input)
end
