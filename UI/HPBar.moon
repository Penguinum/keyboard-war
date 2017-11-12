colorize = require "lib.colorize"
signal = require "hump.signal"
config = require "config"
const = require "const"
import graphics from love

class HPBar
  percentage = 100
  shift = 0
  update_percentage: (max_hp, hp) =>
    -- print "TEST", max_hp, hp
    percentage = math.max(0, hp*100/max_hp)
  draw: =>
    -- love.graphics.getHeight!
    total_width = const.scene_width-shift*2
    hp_width = total_width*percentage/100
    -- print percentage
    colorize {0, 0, 0}, -> graphics.rectangle "fill", shift, 0, total_width, 6
    colorize {20, 200, 20}, -> graphics.rectangle "fill", shift, 0, hp_width, 6
    -- colorize {100, 200, 100}, -> graphics.rectangle "line", shift, 0, total_width, 6
  signal.register "boss_hp", (...) -> @update_percentage(...)

  update: =>
