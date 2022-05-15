return function(level, input)
	return string.format("%s -- [%s] %s", os.date("%Y-%m-%d %H:%M:%S"), level.name, input)
end
