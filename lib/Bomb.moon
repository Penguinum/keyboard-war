-- lovelog = require "lib.lovelog"
-- vector = require "hump.vector"
-- colorize = require "lib.colorize"
-- signal = require "hump.signal"
--config = require "config"
HC = require "HCWorld"

BombManager =
  size: 0
  last: 0
  bombs: {}
  addBomb: (b) =>
    @size += 1
    @bombs[b] = true

  removeBomb: (b) =>
    @bullets[b] = nil
    @size -= 1

  update: (dt) =>
    for b, _ in pairs @bullets
      b\update dt

  draw: () =>
    -- lovelog.print "Bomb count: " .. @size
    for b, _ in pairs @bullets
      b\draw!

  removeAllBullets: =>
    for b, _ in pairs(@bullets)
      b\remove!

class Bullet
  new: (args) =>
    @pos = args.pos
    @rad = 30
    @char = args.char or "*"
    @hitbox = HC\circle(@pos.x, @pos.y, @rad)

  update: (dt) =>

  draw: (dt) =>

  {
    :BombManager
    :Bullet
  }
