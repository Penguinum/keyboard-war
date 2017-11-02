Bullet = require("lib.Bullet").BulletConstructor
unpack = unpack or table.unpack

--- Pattern interpreter

Pattern = (pat) ->
  new_pattern = class
    new: (args) =>
      @bullets = {}
      if type pat.spawn == "table"
        bullets = pat\new args
        for k, bullet in pairs bullets
          Bullet bullet
  return new_pattern

{
  spawn: (name, args) -> Pattern(require("patterns." .. name))(args)
  draw: ->
  update: (dt) ->
}
