Vector = require "hump.vector"
signal = require "hump.signal"
lovelog = require "lib.lovelog"
colorize = require "lib.colorize"
const = require "const"
import Bullet, BulletManager from require "lib.Bullet"
import Bomb, BombManager from require "lib.Bomb"
Controller = require "lib.Controller"
Basechar = require "characters.Base"
HC = require "HCWorld"
StateManager = require "lib.StateManager"
PatternManager = require "lib.PatternManager"

import graphics from love

class Player extends Basechar
  initial_bomb_count = 3
  keys_locked = true
  text: "(=^･ω･^=)"
  width: 70
  speed: 300
  slowspeed: 100
  lives: 3 -- lives
  bombs: 3

  new: =>
    super\__init!
    signal.emit("update_player_info", {lives: @lives, bombs: @bombs})

  draw: =>
    BombManager\draw!
    super\draw!
    if @draw_hitbox
      colorize {255, 0, 0}, -> love.graphics.circle "fill", @pos.x, @pos.y, @hitbox_radius
    lovelog.print "Player hitbox rad: " .. @hitbox_radius
    lovelog.print "Player lives: " .. @lives
    lovelog.print "Player x: " .. @pos.x

  update: (dt) =>
    BombManager\update dt
    if keys_locked
      return
    vec = Vector 0
    if Controller.pressed "left" then
      vec.x = -1
    elseif Controller.pressed "right" then
      vec.x = 1

    if Controller.pressed "down" then
      vec.y = 1
    elseif Controller.pressed "up" then
      vec.y = -1

    if Controller.pressed "shoot" then
      @shoot!

    local speed
    if Controller.pressed "slowdown"
      speed = @slowspeed
      @draw_hitbox = true
    else
      speed = @speed
      @draw_hitbox = false

    @pos = @pos + dt * speed * vec\normalized!
    if @pos.x < 0
      @pos.x = 0
    elseif @pos.x > const.scene_width
      @pos.x = const.scene_width
    if @pos.y > const.scene_height
      @pos.y = const.scene_height
    elseif @pos.y < 0
      @pos.y = 0
    @hitbox\moveTo @pos.x, @pos.y

    if next(HC\collisions(@hitbox))
      for k, v in pairs HC\collisions(@hitbox)
        if k.type == "evil"
          @lives -= 1
          @bombs = initial_bomb_count
          signal.emit("player meets bullet", {lives: @lives, bombs: @bombs})
          if @lives == 0 -- TODO move this somewhere else
            StateManager.switch {screen: "GameOver"}
            SceneManager = require "lib.SceneManager"
            SceneManager\clear!
          return

  shoot: =>
    dist = 20
    if Controller.pressed "slowdown"
      dist = 10
    Bullet{
      pos: @pos + Vector(-dist, -10),
      speed: 1500,
      dir: Vector 0, -1
      type: "good"
      color: {255, 255, 255}
    }
    Bullet{
      pos: @pos + Vector(dist, -10),
      speed: 1500,
      dir: Vector 0, -1
      type: "good"
      color: {255, 255, 255}
    }

  explodeBomb: =>
    -- BulletManager\removeAllBullets!
    Bomb {
      pos: @pos
      lifetime: 0.1
      rad: 100
    }

  keyreleased: (key) =>
    keys_locked = false

  spawnPattern: =>
    PatternManager.spawn "test", {
      pos: @pos
      type: "good"
      color: {100, 100, 100}
      rad: 10
    }

  keypressed: (key) =>
    if Controller.getActionByKey(key) == "bomb"
      if @bombs > 0
        @explodeBomb!
        @bombs -= 1
        signal.emit "bomb_exploded", {bombs: @bombs}
    if Controller.getActionByKey(key) == "pattern4debug"
      @spawnPattern!
