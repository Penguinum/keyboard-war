local moon = require "moonyscript"
moon.insert_loader()

-- love.errhand
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


local function convert_error(msg, level)
  local trace = util.trim(debug.traceback("", 1 + (level or 1)))
  return rewrite_traceback({msg}),
         rewrite_traceback(split(trace, "\n"))
end


love.errhand = function(msg)
	msg = tostring(msg)
  local trace
	msg, trace = convert_error(msg, 2)
  print(msg, trace)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont(math.floor(love.window.toPixels(14)))

	love.graphics.setBackgroundColor(89, 157, 220)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.clear(love.graphics.getBackgroundColor())
	love.graphics.origin()

	local err = {}

	table.insert(err, "Error\n")
	table.insert(err, msg.."\n\n")

	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = string.gsub(p, "\t", "")
	p = string.gsub(p, "%[string \"(.-)\"%]", "%1")

	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.clear(love.graphics.getBackgroundColor())
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	while true do
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			elseif e == "keypressed" and a == "escape" then
				return
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end

-- Game

require("Game").init(arg[2])
_G.inspect = require "lib.inspect"

require("Main")
