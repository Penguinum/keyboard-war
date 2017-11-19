colorize = require "util.colorize"
(args) ->
  old_canvas = love.graphics.getCanvas!
  old_font = love.graphics.getFont!
  new_font = Game.graphics.getFontByName args.font
  canvas = love.graphics.newCanvas new_font\getWidth(args.text), new_font\getHeight!
  love.graphics.setFont new_font
  love.graphics.setCanvas canvas
  colorize args.color, -> love.graphics.printf args.text, 0,  0, canvas\getWidth!, "center"
  love.graphics.setFont old_font
  love.graphics.setCanvas old_canvas
  return love.graphics.newImage canvas\newImageData!
