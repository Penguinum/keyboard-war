colorize = require "util.colorize"
(text, color, font) ->
  old_canvas = love.graphics.getCanvas!
  old_font = love.graphics.getFont!
  new_font = Game.graphics.getFontByName font
  canvas = love.graphics.newCanvas new_font\getWidth(text), new_font\getHeight!
  love.graphics.setFont new_font
  love.graphics.setCanvas canvas
  colorize color, -> love.graphics.printf text, 0,  0, @width, "center"
  love.graphics.setFont old_font
  love.graphics.setCanvas old_canvas
  return love.graphics.newImage canvas\newImageData!
