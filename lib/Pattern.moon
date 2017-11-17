Bullet = require("lib.Bullet").BulletConstructor
unpack = unpack or table.unpack

--- Pattern interpreter

Pattern = (pat) ->
  new_pattern = class
    new: (args) =>
      @bullets = {}
      @drawlayer = pat.drawlayer
      if type pat.spawn == "table"
        bullets = pat\new args
        for k, bullet in pairs bullets
          Bullet bullet
    draw: =>

    update: (dt) =>
      for k, v in pairs @bullets
        v\update dt
  return new_pattern

return Pattern
