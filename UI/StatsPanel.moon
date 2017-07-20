colorize = require "lib.colorize"
config = require "config"
signal = require "hump.signal"
import graphics from love

drawline = (num) ->
  arr = ["*" for i = 1, num]
  table.concat arr, " "

StatsPanel =
  canvas: love.graphics.newCanvas config.panel_width, config.scene_height
  lives: 0
  bombs: 0

  draw: =>
    love.graphics.setFont config.fonts.art_big
    love.graphics.setCanvas @canvas
    colorize {20, 20, 20}, -> graphics.rectangle "fill", 0, 0, @canvas\getWidth!, @canvas\getHeight!
    graphics.printf "Lives: " .. drawline(@lives), 10, 10, 200
    graphics.printf "Bombs: " .. drawline(@bombs), 10, 30, 200
    love.graphics.setFont config.fonts.art
    graphics.printf "Move: left, up, top, bottom", 10, 100, 200
    graphics.printf "Precise move/concentrate: ctrl/shift", 10, 130, 200
    love.graphics.printf "Shoot: z", 10, 160, 200
    graphics.printf "Explode bomb: x", 10, 190, 200
    graphics.printf "Pause: escape", 10, 220, 200
    graphics.setCanvas!
    graphics.draw @canvas, config.scene_width, 0


  update: (dt) =>

signal.register "bomb_exploded", (arg) ->
  StatsPanel.bombs = arg.bombs

signal.register "player_meets_bullet", (arg) ->
  StatsPanel.lives = arg.lives
  StatsPanel.bombs = arg.bombs

signal.register "update_player_info", (arg) ->
  StatsPanel.lives = arg.lives
  StatsPanel.bombs = arg.bombs

return StatsPanel
