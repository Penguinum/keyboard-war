Vector = require "hump.vector"

--- Pattern description
{
  speed: 0
  new: (args) =>
    ret = {}
    for i = -45, 45, 5
      table.insert ret, @spawn({
        pos: args.pos, type: args.type, rad: 5
        type: args.type or "good"
        color: {0, 255, 0}
        angle: (i / 180 * math.pi), radius: 15
      })
    ret
  spawn: (args) => {
    rad: args.rad, color: args.color,
    pos: args.pos + Vector(0, -args.radius)\rotated(args.angle)
    angle: args.angle
    type: args.type
    speed: 0
    update: (dt) =>
      @pos += Vector(0, -@speed)\rotated(@angle)
      @speed += dt * 15
  }
}
