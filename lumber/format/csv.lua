--- Simple log formatter for CSV output.
-- @usage
-- local log = lumber.new((require 'lumber.format.csv'))

local function file_line(x)
	local info = debug.getinfo(x+1)
	return info.short_src, info.currentline
end

local function escape(str)
	if str:match("^[A-Za-z0-9 ]*$") then
		return str
	else
		return '"' .. str:gsub('"', '""') .. '"'
	end
end

return function(level, message)
	return table.concat({
		os.date("%Y-%m-%dT%H:%M:%S%z");
		level.index;
		level.name;
		file_line(3);
	}, ",")
	.. ","
	.. escape(message)
end
