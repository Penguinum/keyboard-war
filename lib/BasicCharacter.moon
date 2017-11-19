Vector = require "hump.vector"
Class = require "hump.class"

Class
  setText: (t) =>
    @text = t

  draw: =>
    love.graphics.printf "dummy text", @pos.x, @pos.y, 100, "center"

  update: (dt) =>
