import BulletManager, Bullet from require "lib.Bullet"
PatternManager = require "lib.PatternManager"
Vector = require "hump.vector"
StatsPanel = require "UI.StatsPanel"
StateManager = require "lib.StateManager"
MusicPlayer = require "lib.MusicPlayer"
Moonshine = require "moonshine"
signal = require "hump.signal"
colorize = require "lib.colorize"
const = require "const"

FX = Moonshine(Moonshine.effects.glow)
FX.glow.strength = 3

local SceneManager
SceneManager =
  canvas: love.graphics.newCanvas(const.scene_width, love.graphics.getHeight!)

  reset: =>
    @enemies = {}

    @statsPanel = StatsPanel {
      width: const.panel_width
      height: const.active_screen_height
    }

    signal.register "dead", (obj) ->
      SceneManager\removeEnemy obj
    signal.register "player meets bullet", (playerstate) ->
      BulletManager\removeAllBullets!
    signal.register "game over", (playerstate) ->
      if playerstate.lives == 0
        MusicPlayer.pauseCurrent!
        StateManager.switch {screen: "GameOver"}
    signal.register "leave scene", ->
      MusicPlayer.pauseCurrent!
    signal.register "resume scene", ->
      MusicPlayer.resumeCurrent!

  update: (dt) =>
    for enemy in pairs @enemies
      enemy\update dt
    if @player
      @player\update dt
    PatternManager\update dt
    BulletManager\update dt
    @statsPanel\update dt

  draw: =>
    love.graphics.setCanvas @canvas
    colorize {20, 20, 20}, ->
      love.graphics.rectangle "fill", 0, 0, @canvas\getWidth!, @canvas\getHeight!
    FX ->
      for enemy, _ in pairs @enemies
        enemy\draw!
      if @player
        @player\draw!
      BulletManager\draw!
    love.graphics.setCanvas!
    love.graphics.draw @canvas, const.hspace, const.vspace, 0, const.scaling, const.scaling
    @statsPanel\draw!

  keyreleased: (key, rawkey) =>
    if StateManager.PLAYABLE_STATE
      if @player
        @player\keyreleased key

  keypressed: (key, rawkey) =>
    if key == "escape"
      MusicPlayer.pauseCurrent!
      StateManager.switch {screen: "PauseMenu", pause: true}
      return
    if @player
      @player\keypressed key

return SceneManager
