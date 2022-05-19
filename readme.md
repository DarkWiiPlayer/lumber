# Lumber

A simple and extensible logging library for Lua

## Provided features

- Log Levels
- Default formatters (Term, File and Plain)
- Function arguments (for expensive debugging info)
- Simple extension interface

## Example

```lua
local lumber = require 'lumber'

log = lumber.new(
	require 'lumber.format.term', -- default is lumber.format.plain
	io.stderr, -- default
	lumber.levels.DEBUG -- default is INFO
)

log("Some Information") -- same as log:info()

log:debug(
	"Open connections:",
	list_open_connections -- Won't get called when log level < debug
)
```

## Custom Formatters:

Formatters are functions that take the log level (as an object) and a single
input string. Function calling and argument concatenation is taken care of by
the library. They are expected to output a single string to be written to the
output object.

```lua
-- Custom formatter to prepend the log level name
local my_formatter(level, input)
	return level.name .. " : " .. input
end
```
