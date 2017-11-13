colorize = require "lib.colorize"
fonts = require "resources.fonts"
signal = require "hump.signal"
import graphics from love

drawline = (num) ->
  arr = ["*" for i = 1, num]
  table.concat arr, " "

class StatsPanel
  lives: 0
  bombs: 0

  new: (args) =>
    @setSize(args.width, args.height)
    signal.register "bomb_exploded", (playerstate) ->
      @bombs = playerstate.bombs

    signal.register "player meets bullet", (playerstate) ->
      @lives = playerstate.lives
      @bombs = playerstate.bombs

    signal.register "update_player_info", (playerstate) ->
      @lives = playerstate.lives
      @bombs = playerstate.bombs

  setSize: (w, h) =>
    @width = w
    @height = h
    @canvas = love.graphics.newCanvas w, h

  draw: =>
    love.graphics.setFont fonts.art_big
    love.graphics.setCanvas @canvas
    colorize {30, 30, 30}, -> graphics.rectangle "fill", 0, 0, @width, @height
    graphics.printf "Lives: " .. drawline(@lives), 10, 10, 200
    graphics.printf "Bombs: " .. drawline(@bombs), 10, 30, 200
    love.graphics.setFont fonts.art
    graphics.printf "Move: left, up, top, bottom", 10, 100, 200
    graphics.printf "Precise move/concentrate: ctrl/shift", 10, 130, 200
    love.graphics.printf "Shoot: z", 10, 160, 200
    graphics.printf "Explode bomb: x", 10, 190, 200
    graphics.printf "Pause: escape", 10, 220, 200
    graphics.setCanvas!
    graphics.draw @canvas, graphics.getWidth! - @width, 0

  update: (dt) =>

return StatsPanel
