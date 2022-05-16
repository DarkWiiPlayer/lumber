--- Simple log formatter that does nothing.
-- All log messages are echoed back without modification.
-- @usage
-- local log = lumber.new((require 'lumber.format.plain'))

return function(level, input)
	return input
end
