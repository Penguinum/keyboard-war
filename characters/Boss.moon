vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
config = require "config"
local SceneManager
StateManager = require "lib.StateManager"
import Bullet, CircleBullet from require "lib.Bullet"
import Mode from require "lib.Modes"
import graphics, keyboard from love
Vector = require "hump.vector"
Basechar = require "lib.Basechar"
HPBar = require "UI.HPBar"
HC = require "HCWorld"

death = Mode{
  id: "death"
  init_func: () =>
    @exploded = nil
    cx = config.scene_width/2
    @diff_pos = vector(cx, @pos.y) - @pos
    @income_pos = @pos
    @circle_bullets_dt = 0
    @circle_bullets_da = 0

  update_func: (dt, tt) =>
    if tt < 1
      cx = config.scene_width/2
      @direction = (@pos.x > cx) and "left" or "right"
      @text = @texts[@direction]
      @pos = @income_pos - tt*tt*@diff_pos + tt*2*@diff_pos
    elseif tt < 2
      @pos = vector(config.scene_width/2, @pos.y)
      @circle_bullets_dt += dt
      @text = ""
      if @circle_bullets_dt >= 0.2
        if not @exploded
          love.audio.newSource("sfx/boss_explosion.ogg")\play!
          @exploded = true
        @circle_bullets_dt = 0
        @spawnCircleBullets{
          n: 20
          da: @circle_bullets_da*10
          aspeed: 20
          color: {220, 0, 0}
          rad: 5
        }
        @spawnCircleBullets{
          n: 20
          da: -@circle_bullets_da*10
          aspeed: -20
          color: {220, 0, 0}
          rad: 5
        }
        @circle_bullets_da += 1

    elseif tt > 7
      StateManager.switch "YouWin"
      SceneManager = require "lib.SceneManager"
      SceneManager\clear!

}
appear = Mode {
  id: "appear"
  init_func: () =>
    signal.emit("boss_hp", @max_hp, @hp)
    @diff_pos = @spawn_pos - @income_pos
  update_func: (dt, tt) =>
    if tt < 1
      @pos = @income_pos - tt*tt*@diff_pos + tt*2*@diff_pos
    else
      @pos = @spawn_pos
      @mode = "walk"

}
walk = Mode{
  id: "walk"
  init_func: () =>

  update_func: (dt, tt) =>
    vec = vector 0
    if math.random! > 0.99
      @direction = (@direction == "right") and "left" or "right"
      @text = @texts[@direction]
    if math.random! > 0.96
      player_pos = SceneManager\getPlayerPosition!
      for d1 = -1, 1
        for d2 = -1, 1
          @shoot @pos.x + d1*10, @pos.y + 10, player_pos.x + d2*10, player_pos.y
    if @direction == "left" then
      vec.x = -1
    else
      vec.x = 1
    @pos = @pos + dt * @speed * vec\normalized!
    if @pos.x < 0
      @pos.x = 0
      @direction = "right"
    elseif @pos.x > config.scene_width
      @pos.x = config.scene_width
      @direction = "left"
    print "total time", tt
    if tt > 4
      @mode = "rage"

}
rage = Mode{
  id: "rage"
  damage: 0.2
  init_func: () =>
    @circle_bullets_dt = 0
    @circle_bullets_da = 0
    --@pos.x = 0
    cx = config.scene_width/2
    @diff_pos = vector(cx, @pos.y) - @pos
    @income_pos = @pos

  update_func: (dt, tt) =>
    if tt < 1
      cx = config.scene_width/2
      -- print "pos.x", pos.x, "cx", cx, "next mode", @next_mode
      @direction = (@pos.x > cx) and "left" or "right"
      @text = @texts[@direction]
      @pos = @income_pos - tt*tt*@diff_pos + tt*2*@diff_pos
    else
      @pos = vector(config.scene_width/2, @pos.y)
      @circle_bullets_dt += dt
      if @circle_bullets_dt >= 0.15
        @circle_bullets_dt = 0
        @spawnCircleBullets{
          n: 20
          da: @circle_bullets_da
          aspeed: 0
          color: {0, 0, 255}
        }
        @spawnCircleBullets{
          n: 5
          da: -@circle_bullets_da * 1.5
          aspeed: -40
          color: {255, 255, 0}
          rad: 5
        }
        @circle_bullets_da += 1
    if tt > 5
      @mode = "walk"

}
boss_modes = {
  "walk": walk
  "rage": rage
  "appear": appear
  "death": death
  "MAIN": "appear"
}

class Enemy extends Basechar
  new: (args) =>
    SceneManager = require "lib.SceneManager"
    @pos = args.income_pos
    @income_pos = args.income_pos
    @spawn_pos = args.pos
    @hitbox_radius = 10
    @width = 70
    @height = 15
    hw, hh = @width/2, @height/2
    @hitbox = HC\polygon @pos.x - hw, @pos.y - hh,
                         @pos.x + hw, @pos.y - hh,
                         @pos.x + hw, @pos.y + hh,
                         @pos.x - hw, @pos.y + hh
    -- @hitbox = HC\circle args.income_pos.x, args.income_pos.y, @hitbox_radius
    @max_hp = 500
    @hp = @max_hp
    @texts = {
      right: "(凸ಠ益ಠ)凸"
      left: "凸(ಠ益ಠ凸)"
    }
    @direction = "right"
    @mode = boss_modes["MAIN"]
    @pmode = "nil"
    @text = [[(凸ಠ益ಠ)凸]]
    @speed = 100
    @modes = boss_modes

  update: (dt) =>
    HPBar\update dt
    -- @modes[@mode](@,dt)
    if @mode ~= @pmode
      @modes[@mode]\init(@)
      @pmode = @mode
    @modes[@mode]\update(@,dt)
    @hitbox\moveTo @pos.x, @pos.y
    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "good"
          @hp -= @modes[@mode].damage
          signal.emit("boss_hp", @max_hp, @hp)
          if @hp <= 0
            @mode = "death"

  spawnCircleBullets: (args) =>
    for i = 0, args.n-1
      a = i*(math.pi*2)/args.n
      cx, cy, r, a = config.scene_width/2, @pos.y, 1, a + args.da
      CircleBullet{
        center_pos: Vector(cx, cy)
        r_spawn: r
        pos: Vector(cx, cy) + vector.fromPolar(a, r)
        speed: 80
        angle_speed: args.aspeed
        color: args.color
        char: "*"
        type: "evil"
        rad: args.rad
      }

  shoot: (x, y, tx, ty) =>
    --print "VECTORZ", SceneManager\getPlayerPosition!, @pos
    dir = Vector(tx, ty) - Vector(x, y)
    bullet = Bullet{
      pos: Vector(x, y)
      -- speed: math.random(100, 200)
      speed: 200
      dir: dir\normalized!
      type: "evil"
    }
    bullet.update = (dt) =>
      @pos += @speed * dt * @dir
      @hitbox\moveTo @pos.x, @pos.y
      if @pos.y < 0 or @pos.y > config.scene_height or @pos.x < 0 or @pos.x > config.scene_width
        @remove!

  draw: =>
    super\draw!
    HPBar\draw!
    lovelog.print "Boss's hp: " .. @hp
