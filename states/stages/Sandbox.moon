SceneManager = require "lib.SceneManager"
StateManager = require "lib.StateManager"
Vector = require "hump.vector"
import Bullet from require "lib.Bullet"
lovelog = require "lib.lovelog"
fonts = require "resources.fonts"

class Stage
  -- canvas = love.graphics.newCanvas love.graphics.getWidth! - 200, love.graphics.getHeight!
  enter: =>
    @time = 0
    @current_event = 1
    love.graphics.setFont fonts.art
    SceneManager\spawnPlayer Vector(0.5, 0.9)
    -- SceneManager\spawnBoss Vector(0.5, 0.05)

  update: (dt) =>
    SceneManager\update dt
    @time += dt

  draw: =>
    SceneManager\draw!
