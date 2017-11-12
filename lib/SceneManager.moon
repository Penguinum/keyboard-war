import BulletManager, Bullet from require "lib.Bullet"
PatternManager = require "lib.PatternManager"
Vector = require "hump.vector"
Boss = require "characters.Boss"
SimpleEnemy = require "characters.SimpleEnemy"
Player = require "characters.Player"
StatsPanel = require "UI.StatsPanel"
StateManager = require "lib.StateManager"
MusicPlayer = require "lib.MusicPlayer"
Moonshine = require "moonshine"
fonts = require "resources.fonts"
lovelog = require "lib.lovelog"
signal = require "hump.signal"
colorize = require "lib.colorize"
const = require "const"

FX = Moonshine(Moonshine.effects.glow)
FX.glow.strength = 3

class SceneManager
  enemies = {}
  player = nil
  canvas: love.graphics.newCanvas const.scene_width, love.graphics.getHeight!

  new: (args) =>
    @statsPanel = StatsPanel { width: 200, height: 600}
    @scene = args.scene
    @spawnPlayer!

    signal.register "dead", (obj) ->
      SceneManager\removeEnemy obj

  addEnemy: (e) =>
    enemies[e] = true

  spawnPlayer: (pos) =>
    player = Player!
    player\setPos const.scene_width * 0.5, const.scene_height * 0.9

  spawnBoss: (args) =>
    pos_x = args.pos.x * const.scene_width
    pos_y = args.pos.y * const.scene_height
    income_pos_x = args.income_pos.x * const.scene_width
    income_pos_y = args.income_pos.y * const.scene_height
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
    @statsPanel\update dt
    if @scene.update
      @scene\update dt

  draw: =>
    lovelog.reset!
    love.graphics.setCanvas @canvas
    love.graphics.setFont fonts.art
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
    @statsPanel\draw!
    lovelog.print "FPS: " .. love.timer.getFPS!
    if @scene.draw
      @scene\draw!

  keyreleased: (key, rawkey) =>
    if StateManager.PLAYABLE_STATE
      player and player\keyreleased key

  keypressed: (key, rawkey) =>
    if StateManager.PLAYABLE_STATE and key == "escape"
      MusicPlayer.sendEvent {tag:"Stage1", event:"pause"}
      StateManager.switch {screen: "PauseMenu", pause: true}
      return
    if StateManager.PLAYABLE_STATE
      player and player\keypressed key

return SceneManager
