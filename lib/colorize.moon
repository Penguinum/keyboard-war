(color, f) ->
  old_color = {love.graphics.getColor()}
  love.graphics.setColor({color[1] / 255, color[2] / 255, color[3] / 255, color[4]})
  f()
  love.graphics.setColor(unpack(old_color))
