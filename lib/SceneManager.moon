import BulletManager, Bullet from require "lib.Bullet"
PatternManager = require "lib.PatternManager"
Vector = require "hump.vector"
Boss = require "characters.Boss"
SimpleEnemy = require "characters.SimpleEnemy"
Player = require "characters.Player"
StatsPanel = require "UI.StatsPanel"
StateManager = require "lib.StateManager"
Moonshine = require "moonshine"
lovelog = require "lib.lovelog"
signal = require "hump.signal"
colorize = require "lib.colorize"
config = require "config"

enemies = {}
local player

FX = Moonshine(Moonshine.effects.glow)
FX.glow.strength = 3

SceneManager =
  canvas: love.graphics.newCanvas config.scene_width, love.graphics.getHeight!

  addEnemy: (e) =>
    enemies[e] = true

  spawnPlayer: (pos) =>
    pos_x = pos.x * config.scene_width
    pos_y = pos.y * config.scene_height
    player = Player!
    player\setPos pos_x, pos_y

  spawnBoss: (args) =>
    pos_x = args.pos.x * config.scene_width
    pos_y = args.pos.y * config.scene_height
    income_pos_x = args.income_pos.x * config.scene_width
    income_pos_y = args.income_pos.y * config.scene_height
    boss = Boss{
      pos: Vector(pos_x, pos_y)
      income_pos: Vector(income_pos_x, income_pos_y)
      modes: args.modes
    }
    enemies[boss] = true

  spawnEnemy: (arg) =>
    enemy = SimpleEnemy arg
    enemies[enemy] = true

  removeEnemy: (obj) =>
    enemies[obj] = nil

  getPlayerPosition: =>
    player.pos

  setPlayer: (p) =>
    player = p

  clear: =>
    enemies = {}
    BulletManager\removeAllBullets!

  update: (dt) =>
    for enemy, _ in pairs enemies
      enemy\update dt
    player\update dt
    PatternManager\update dt
    BulletManager\update dt
    StatsPanel\update dt

  draw: =>
    lovelog.reset!
    love.graphics.setCanvas @canvas
    love.graphics.setFont config.fonts.art
    colorize {10, 10, 10}, ->
      love.graphics.rectangle "fill", 0, 0, @canvas\getWidth!, @canvas\getHeight!

    for enemy, _ in pairs enemies
      enemy\draw!
    player\draw!
    PatternManager\draw!
    BulletManager\draw!
    love.graphics.setCanvas!
    FX ->
      love.graphics.draw @canvas
    StatsPanel\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!

  keyreleased: (key, rawkey) =>
    state = StateManager.getState!
    state.keyreleased and state\keyreleased key
    player and player\keyreleased key

  keypressed: (key, rawkey) =>
    state = StateManager.getState!
    state.keypressed and state\keypressed key
    player and player\keypressed key

signal.register "dead", (obj) ->
  SceneManager\removeEnemy obj

return SceneManager
