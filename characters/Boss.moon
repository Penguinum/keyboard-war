vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
config = require "config"
import Bullet from require "lib.Bullet"
import graphics, keyboard from love
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HC = require "HCWorld"

class Enemy extends Basechar
  new: (pos) =>
    @hitbox_radius = 10
    @hitbox = HC\circle @pos.x, @pos.y, @hitbox_radius
    @pos = pos or @pos
    @max_hp = 100
    @hp = @max_hp
    @texts = {
      right: "(凸ಠ益ಠ)凸"
      left: "凸(ಠ益ಠ凸)"
    }
    @mode = "right"
    @text = [[(凸ಠ益ಠ)凸]]
    @width = 100
    @speed = 100
    @circle_bullets_dt = 0

  circleBulletsTimer: =>
    print @circle_bullets_dt
    if @circle_bullets_dt >= 0.5
      @circle_bullets_dt = 0
      @spawnCircleBullets!

  update: (dt) =>
    -- super\update dt
    @circle_bullets_dt += dt
    @circleBulletsTimer!
    vec = vector 0
    if math.random! > 0.99
      @mode = (@mode == "right") and "left" or "right"
      @text = @texts[@mode]
    if math.random! > 0.96
      @shoot!
    if @mode == "left" then
      vec.x = -1
    else
      vec.x = 1
    @pos = @pos + dt * @speed * vec\normalized!
    if @pos.x < 0
      @pos.x = 0
      @mode = 'right'
    elseif @pos.x > config.scene_width
      @pos.x = config.scene_width
      @mode = 'left'
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "good"
          @hp -= 1
          signal.emit("boss_hp", @max_hp, @hp)
          if @hp == 0
            signal.emit("Stage1_end")
    @hitbox\moveTo @pos.x, @pos.y

  bullet1: (x, y) =>
    bullet = Bullet{
      pos: Vector(x, y)
      speed: math.random(30, 200)
      dir: Vector(math.random! - 0.5, math.random!)\normalized!
      char: "9"
      type: "evil"
    }
    bullet.update = (dt) =>
      @pos += @speed * dt * @dir
      @hitbox\moveTo @pos.x, @pos.y
      if @pos.y < 0 or @pos.y > love.graphics.getHeight! or @pos.x < 0 or @pos.x > config.scene_width
        @remove!

  bullet2: (cx, cy, r, a) =>
    bullet = Bullet{
      pos: Vector(cx, cy) + vector.fromPolar(a, r)
      speed: 40
      -- dir: Vector(math.random! - 0.5, math.random!)\normalized!
      char: "*"
      type: "evil"
    }
    bullet.r_vector = vector.fromPolar(a, r)
    bullet.center_pos = Vector(cx, cy)
    --print bullet.pos, bullet.center_pos, cx, cy
    --print vector.fromPolar(a, r)
    bullet.angle = a
    bullet.anglespeed = 1
    bullet.update = (dt) =>
      print @r_vector
      @r_vector = @r_vector\rotated(@anglespeed * dt)
      @angle = @r_vector\toPolar()['x']
      @r_vector += @r_vector\normalized! * @speed * dt
      @pos = @center_pos + @r_vector

      @hitbox\moveTo @pos.x, @pos.y
      if @pos.y > love.graphics.getHeight!
        @remove!



  spawnCircleBullets: =>
    for i = 0, 19
      a = i*20*(math.pi*2)/360
      @bullet2 config.scene_width/2, @pos.y, 50, a

  shoot: =>
    @bullet1 @pos.x, @pos.y + 20
    -- @bullet2 config.scene_width/2, @pos.y, 50, math.pi/2

  draw: =>
    super\draw!
    lovelog.print "Boss's hp: " .. @hp
