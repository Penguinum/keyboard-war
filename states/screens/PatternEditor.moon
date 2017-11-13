UI = require "lib.UI"
PatternManager = require "lib.PatternManager"
import BulletManager from require "lib.Bullet"
Vector = require "hump.vector"
colorize = require "lib.colorize"
-- BulletManager = require "BulletManager"

layout = {
  "panel",
  left: 0, right: 0, top: 0, bottom: 0
  content: {
    canvas: {
      "canvas", id: "DrawingArea"
      left: 0, right: 200, top: 0, bottom: 0
    }
    {
      "panel"
      right: 0, width: 200, top: 0, bottom: 0
      content: {
        button_run: {
          "button"
          left: 10, right: 10, top: 10, height: 20
          text: "Test"
          OnClick: =>
            x2, y2 = UI.getWidget("DrawingArea")\GetSize!
            PatternManager.spawn "test", {
              pos: Vector(x2/2, y2/2)
              type: "good"
              color: {100, 100, 100}
              rad: 10
            }
        }
        button_hello: {
          "button"
          left: 10, right: 10, bottom: 10, height: 20
          text: "Hello void"
          OnClick: =>
            UI.popup {
              "frame",
              center: true, height: 200, width: 300
              content: {
                layout: {
                  "button", left: 10, right: 10, top: 30, height: 20
                  text: "some text"
                }
              }
            }
        }
      }
    }
  }
}

class PatternEditor
  new: =>
    UI.inject(@)
    UI.load layout

  draw: =>
    love.graphics.setCanvas UI.getWidget("DrawingArea")\GetImage!
    love.graphics.clear 0, 0, 0
    BulletManager\draw!
    love.graphics.setCanvas!

  update: (dt) =>
    BulletManager\update(dt)
