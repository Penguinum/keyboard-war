Vector = require "hump.vector"
Class = require "hump.class"
copy = require "util.copy"

BasicCharacter = Class
  setText: (t) =>
    @text = t

  setPos: (x, y) =>
    @pos = Vector(x, y)

  draw: =>
    love.graphics.printf "dummy text", @pos.x, @pos.y, 100, "center"

  update: (dt) =>

return (args) ->
  args = copy args
  args.__includes = BasicCharacter
  return Class args
