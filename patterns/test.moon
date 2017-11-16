Vector = require "hump.vector"

--- Pattern description
{
  parameters: {
    {
      "rad"
      type: "number"
      max: 10
      min: 5
      default: 5
    }
    {
      "color"
      type: "color"
      default: { 255, 255, 255 }
    }
  }
  speed: 0
  new: (args) =>
    ret = {}
    for i = -180, 180, 10
      table.insert ret, @spawn({
        pos: args.pos, type: args.type, rad: args.rad or 5
        type: args.type or "good"
        color: args.color or {0, 255, 0}
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
      @speed += dt * dt * 500
  }
}
