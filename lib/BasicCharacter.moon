Vector = require "hump.vector"
Class = require "hump.class"

Class
  setText: (t) =>
    @text = t

  setPos: (x, y) =>
    @pos = Vector(x, y)

  draw: =>
    love.graphics.printf "dummy text", @pos.x, @pos.y, 100, "center"

  update: (dt) =>
