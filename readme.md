# Lumber

A simple and extensible logging library for Lua

## Provided features

- Log Levels
- Default formatters (Term, File and Plain)
- Function arguments (for expensive debugging info)
- Simple extension interface

## Example

	local lumber = require 'lumber'

	log = lumber.new {
		format = require 'lumber.format.term'; -- default is lumber.format.plain
		out = io.stderr; -- default
		level = lumber.levels.DEBUG; -- default is INFO
		separator = "\n"; -- default is single space
		filter = require 'inspect'; -- default `tostring`
	}

	log("Some Information") -- same as log:info()

	log("Foo", "Bar") -- Concatenated with `separator`

	log(some_object) -- Fed through `filter` before printing

	log:debug(
		"Open connections:",
		list_open_connections -- Won't get called when log level < debug
	)

## Global Logger

Lumber provides a utility module to help programs setting a global logger and
libraries check for its presence and use it.

A library that wants to log information can simply require the `lumber.global`
module and treat it as its logger. When no global logger is configured, its
logging methods will simply do nothing.

An application that wants to introduce logging just has to call the module table
with a logger object, or an options table as expected by `lumber.new`. This call
will end by returning the global logger for easier chaining.

The global logger is stored in the `_G.logger` variable, but should generally
only be used through this module.

	require("lumber.global") {
		format = require 'lumber.format.term';
		context = function()
			local info = debug.getinfo(3)
			return info.short_src
		end;
		level = 5;
	}

## Custom Context:

Loggers can be configured with an additional context function.
This can be used, for example, to add the current thread:

	log.context = function() 
		local thread, main = coroutine.running()
		if thread ~= nil and not main then
			return string.format("%p", thread)
		end
	end

Or the current file:

	log.context = function()
		local info = debug.getinfo(3)
		return info.short_src .. ":" .. info.currentline
	end

to the log output. The result(s) of the context function will be passed at the
end of the parameter list to the formatter function.

## Custom Formatters:

Formatters are functions that take the log level (as an object) and a single
input string. Function calling and argument concatenation is taken care of by
the library. They are expected to output a single string to be written to the
output object.

	-- Custom formatter to prepend the log level name
	local my_formatter(level, input)
		return level.name .. " : " .. input
	end

## lnav

If you use [`lnav`](https://lnav.org), copy the contents of the `lnav` directory
to `~/.lnav/formats/lumber/`.
