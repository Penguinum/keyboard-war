UI = require "lib.UI"
PatternManager = require "lib.PatternManager"
import BulletManager from require "lib.Bullet"
Vector = require "hump.vector"
-- BulletManager = require "BulletManager"

Pattern = {
  id: "bomb"
}

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
        text_name: {
          "text", id: "title-current-pattern"
          left: 10, top: 10, right: 10, height: 20
          text: "Pattern: " .. Pattern.id
        }
        button_pattern_list: {
          "button"
          left: 10, right: 10, top: 30, height: 20
          text: "Select pattern"
          OnClick: =>
            files = love.filesystem.getDirectoryItems("patterns")
            patterns = {}
            for _, file in pairs files
              table.insert(patterns, file\match("(.+)%.moon"))
            UI.popup {
              "frame", id: "pattern-select"
              right: 0, width: 300, top: 0, height: 300
              content: {
                {
                  "text"
                  left: 10, right: 10, top: 30, height: 20
                  text: "Select pattern..."
                }
                {
                  "list",
                  left: 10, right: 10, top: 50, bottom: 10
                  items: patterns
                  OnSelect: (item) =>
                    Pattern.id = item
                    UI.getWidget("pattern-select")\Remove!
                    UI.getWidget("title-current-pattern")\SetText("Current pattern: " .. item)
                }
              }
            }
        }
        button_run: {
          "button"
          left: 10, right: 10, top: 60, height: 20
          text: "Run pattern"
          OnClick: =>
            x2, y2 = UI.getWidget("DrawingArea")\GetSize!
            PatternManager.spawn Pattern.id, {
              pos: Vector(x2/2, y2/2)
              type: "good"
              rad: 10
            }
        }
        slider_test: {
          "slider"
          left: 10, right: 10, top: 90, height: 20
          slidetype: "horizontal"
          min: 0, max: 255
        }
        colorpicker_test: {
          "colorpicker"
          left: 10, right: 10, top: 120, height: 70
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
