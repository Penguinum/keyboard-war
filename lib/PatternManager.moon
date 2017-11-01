Bullet = require("lib.Bullet").BulletConstructor
unpack = unpack or table.unpack

--- Pattern interpreter

Pattern = (pat) ->
  new_pattern = class
    new: (pos) =>
      @bullets = {}
      if type pat.spawn == "table"
        bullets = pat\new {:pos}
        for k, bullet in pairs bullets
          Bullet bullet
  return new_pattern

{
  spawn: (name, pos) -> Pattern(require("patterns." .. name))(pos)
  draw: ->
  update: (dt) ->
}
