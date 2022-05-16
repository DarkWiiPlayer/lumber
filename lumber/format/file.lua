--- Simple log formatter for file output.
-- Writes messages as `YYYY-MM-DD HH:MM:SS -- [LEVEL] log message`.
-- @usage
-- local log = lumber.new((require 'lumber.format.file'))

return function(level, input)
	return string.format("%s -- [%s] %s", os.date("%Y-%m-%d %H:%M:%S"), level.name, input)
end
