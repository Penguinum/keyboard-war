-- lovelog = require "lib.lovelog"
-- vector = require "hump.vector"
colorize = require "lib.colorize"
-- signal = require "hump.signal"
--config = require "config"
Synth = require "lib.Synth"
HC = require "HCWorld"
import BulletManager from require "lib.Bullet"
import graphics from love

BombManager =
  size: 0
  last: 0
  bombs: {}
  addBomb: (b) =>
    @size += 1
    @bombs[b] = true

  removeBomb: (b) =>
    @bombs[b] = nil
    @size -= 1

  update: (dt) =>
    for b, _ in pairs @bombs
      if b.lifetime > b.max_lifetime
        b\remove!
      b\update dt

  draw: () =>
    -- lovelog.print "Bomb count: " .. @size
    for b, _ in pairs @bombs
      b\draw!

  removeAllBombs: =>
    for b, _ in pairs(@bombs)
      b\remove!

class Bomb
  new: (args) =>
    Synth\play {
      gen: "WhiteNoise"
      length: 0.1
      frequency: 1
    }
    @pos = args.pos
    @rad = args.rad
    @hitbox = HC\circle(@pos.x, @pos.y, @rad)
    @lifetime = 0
    @max_lifetime = args.lifetime or 0
    @color = {0, 0, 255}

    BombManager\addBomb @

  update: (dt) =>
    @lifetime += dt
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "evil"
          print "EVILBOOLET", k
          BulletManager\removeBulletWithHitbox(k)

  draw: =>
    colorize @color, -> graphics.circle "line", @pos.x, @pos.y, @rad

  remove: =>
    HC\remove @hitbox
    BombManager\removeBomb @

{
  :BombManager,
  :Bomb
}
