local errors = require "moonscript.errors"
local util = require "moonscript.util"
local split, pos_to_line = util.split, util.pos_to_line
local line_tables = require "moonscript.line_tables"

local function rewrite_single(trace)
  local fname, line, msg = trace:match('^(.-):(%d+): (.*)$')
  local tbl = line_tables["@" .. tostring(fname)]
  if fname and tbl then
    return table.concat({
      fname,
      ":",
      errors.reverse_line_number(fname, tbl, line, {}),
      ": ",
      "(",
      line,
      ") ",
      msg
    })
  else
    return trace
  end
end

local function process_line(trace_line)
  trace_line = util.trim(trace_line)
  local fname, line, msg = trace_line:match('^(.-):(%d+): (.*)$')
  if fname and fname:match(".+%.moon$") then
    return rewrite_single(trace_line)
  end
  return trace_line
end

local function rewrite_traceback(lines)
  for i, line in ipairs(lines) do
    lines[i] = process_line(line)
  end
  return table.concat(lines, "\n\t")
end

return function(msg)
	msg = tostring(msg)
  local trace = util.trim(debug.traceback("", 2))
  print(rewrite_traceback({msg}))
  print(rewrite_traceback(split(trace, "\n")))
end
