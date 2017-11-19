vector = require "hump.vector"
colorize = require "util.colorize"
const = require "const"
BulletManager = require "lib.BulletManager"
HC = require "HCWorld"
import graphics from love

class Bullet
  new: (args) =>
    @pos = args.pos
    @rad = args.rad or 3
    @speed = args.speed or 0
    @dir = args.dir or vector(0, 0)
    @char = args.char or "*"
    @hitbox = HC\circle(@pos.x, @pos.y, @rad)
    if args.type == "good"
      r = @rad
      @hitbox = HC\polygon @pos.x - r, @pos.y - r - 7,
                           @pos.x + r, @pos.y - r - 7,
                           @pos.x + r, @pos.y + r,
                           @pos.x - r, @pos.y + r
    @hitbox.type = args.type or "evil"
    @hitbox.bullet = @
    @color = args.color or {0, 0, 255}

    BulletManager\addBullet @


  update: (dt) =>
    @pos += @speed * dt * @dir
    @hitbox\moveTo @pos.x, @pos.y
    if @pos.y < 0 or @pos.y > love.graphics.getHeight! or @pos.x < 0 or @pos.x > const.scene_width
      @remove!

  draw: =>
    colorize @color, -> graphics.circle "fill", @pos.x, @pos.y, @rad
    if const.debug
      @hitbox\draw!
    -- graphics.printf s@char, @pos.x - @rad, @pos.y - @rad, 2 * @rad, "center"

  remove: =>
    HC\remove @hitbox
    BulletManager\removeBullet @


class BulletConstructor extends Bullet
  new: (args) =>
    for k, v in pairs(args)
      if k ~= "update"
        @[k] = v
      else
        @preupdate = v
    @color = @color or {0, 0, 255}
    @hitbox = HC\circle(@pos.x, @pos.y, @rad)
    if args.type == "good"
      r = @rad
      @hitbox = HC\polygon @pos.x - r, @pos.y - r - 7,
                           @pos.x + r, @pos.y - r - 7,
                           @pos.x + r, @pos.y + r,
                           @pos.x - r, @pos.y + r
    @hitbox.type = args.type or "evil"
    @hitbox.bullet = @
    BulletManager\addBullet @

  update: (dt) =>
    @preupdate dt
    if @removed
      @remove!
      return
    @hitbox\moveTo @pos.x, @pos.y
    morespace = 200
    if @pos.y < -morespace or @pos.y > love.graphics.getHeight! + morespace or
       @pos.x < -morespace or @pos.x > const.scene_width + morespace
      @remove!


class CircleBullet extends Bullet
  new: (args) =>
    super\__init(args)
    @center_pos = args.center_pos
    @r_vector = args.center_pos - args.pos
    @anglespeed = args.angle_speed or 1
    @r_spawn = args.r_spawn
    @ac = args.ac or 2
    @pos = @center_pos + @r_vector

  update: (dt) =>
    @r_vector = @r_vector\rotated((@r_spawn / @r_vector\toPolar!["y"]) * @anglespeed * dt)
    @r_vector += @r_vector\normalized! * @speed * dt
    @speed += @ac
    @pos = @center_pos + @r_vector
    @hitbox\moveTo @pos.x, @pos.y
    scene_corner = vector(0, const.scene_height)
    dr = scene_corner - @center_pos
    if dr\toPolar!["y"] < @r_vector\toPolar!["y"]
      @remove!
{
  :CircleBullet,
  :Bullet,
  :BulletManager,
  :BulletConstructor
}
