const = require "const"
colorize = require "util.colorize"
StatsPanel = require "UI.StatsPanel"
StateManager = require "lib.StateManager"
Moonshine = require "moonshine"
BulletManager = require "lib.BulletManager"

Objects = {}
Drawlayers = {}
sortedLayers = {}
KeypressSubscribers = {}

FX = Moonshine(Moonshine.effects.glow)
FX.glow.strength = 3

Scene =
  getWidth: => const.scene_width
  getHeight: => const.scene_height
  canvas: love.graphics.newCanvas const.scene_width, const.scene_height
  reset: =>
    Objects = {}
    Drawlayers = {}
    sortedLayers = {}

  resize: =>
    @statsPanel = StatsPanel {
      width: const.panel_width
      height: const.active_screen_height
    }
    @width = const.scene_width
    @height = const.scene_height

  spawn: (obj, pos) =>
    if pos
      obj.pos = pos
    Objects[obj] = true
    layer = obj.drawlayer
    if not Drawlayers[layer]
      sortedLayers = {}
      Drawlayers[layer] = {}
      for k, v in pairs Drawlayers
        table.insert(sortedLayers, k)
      table.sort(sortedLayers)
    Drawlayers[layer][obj] = true
    if obj.keypressed
      KeypressSubscribers[obj] = true

  remove: (obj) =>
    Objects[obj] = nil
    if obj.drawlayer
      Drawlayers[obj.drawlayer][obj] = nil
    KeypressSubscribers[obj] = nil

  update: (dt) =>
    for object in pairs Objects do
      object\update dt

  draw: =>
    love.graphics.setCanvas @canvas
    colorize {20, 20, 20}, ->
      love.graphics.rectangle "fill", 0, 0, @canvas\getWidth!, @canvas\getHeight!
    FX ->
      for z, id in ipairs sortedLayers
        layer = Drawlayers[id]
        for object in pairs layer
          object\draw!
    love.graphics.setCanvas!
    love.graphics.draw @canvas, const.hspace, const.vspace, 0, const.scaling, const.scaling
    @statsPanel\draw!

  keyreleased: (key, rawkey) =>
    if StateManager.PLAYABLE_STATE
      for object in pairs KeypressSubscribers
        if object.keyreleased
          object\keyreleased key

  keypressed: (key, rawkey) =>
    if key == "escape"
      Game.music\pauseCurrent!
      StateManager.switch {screen: "PauseMenu", pause: true}
      return
    for object in pairs KeypressSubscribers
      object\keypressed key

return Scene
