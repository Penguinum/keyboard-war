Controller = require "lib.Controller"
log = require "log.log"

funcs =
  spawn: (what, ...) ->
    if what == "pattern"
      log.info "No patterns for you"

split = (s) -> [word for word in s\gmatch("%S+")]

local console

console =
  input: ""
  keyreleased: (key) ->
  keypressed: (key) ->
    if key == "space"
      key = " "
    if Controller.pressed("shift")
      if key\match("[a-z]")
        key = key\upper!
      elseif key == "-"
        key = "_"
    if key == "escape"
      if console.input == ""
        console.close!
      else
        console.input = ""
    elseif #key == 1 and key\match("[a-zA-Z0-9%s_-]")
      console.input = console.input .. key
    elseif key == "backspace"
      console.input = #console.input > 0 and console.input\sub(1, #console.input - 1) or ""
    elseif key == "return"
      console.execute!
  close: =>
    Controller.unlock!
    console.active = nil
    console.input = ""
  open: =>
    Controller.lock!
    console.active = true
  draw: =>
    if not console.active
      return
    love.graphics.print("> " .. console.input)
  execute: =>
    args = split console.input
    funcname = table.remove args, 1
    ok = pcall -> funcs[funcname](unpack(args))
    if ok
      console.close!

console
