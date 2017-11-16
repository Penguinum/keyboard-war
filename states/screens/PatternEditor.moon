UI = require "lib.UI"
PatternManager = require "lib.PatternManager"
import BulletManager from require "lib.Bullet"
Vector = require "hump.vector"
inspect = require "inspect"
-- BulletManager = require "BulletManager"

love.window.setMode(0, 0, {fullscreen: false})

Pattern = {
  id: "bomb"
}

getPattern = (name) -> require("patterns." .. name)

generateEditor = (args) ->
  layout = {}
  parameters = args.parameters
  for i, parameter in ipairs(parameters)
    if parameter.type == "number"
      layout[i] = {
        "slider"
        left: 10, right: 10, top: (i - 1) * 25 + 5, height: 23
        min: parameter.min, max: parameter.max, default: parameter.default
        slidetype: "horizontal"
      }
  return {
    "panel"
    left: args.left, right: args.right, width: args.width
    top: args.top, bottom: args.bottom, height: args.height
    content: layout
  }

patternEditorForm = {
  "panel",
  left: 0, right: 0, top: 0, bottom: 0
  content: {
    canvas: {
      "canvas", id: "DrawingArea"
      left: 0, right: 200, top: 0, bottom: 0
    }
    {
      "panel", id: "panel-pattern-editor"
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
                    Pattern.pattern = getPattern(item)
                    panel_editor = UI.getWidget("panel-pattern-editor")
                    UI.load(generateEditor({
                      left: 0, right: 0, top: 100, bottom: 0
                      parameters: Pattern.pattern.parameters
                    }), panel_editor)
                    UI.removeWidget("pattern-select")
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
      }
    }
  }
}

class PatternEditor
  new: =>
    UI.inject(@)
    UI.load patternEditorForm

  draw: =>
    love.graphics.setCanvas UI.getWidget("DrawingArea")\GetImage!
    love.graphics.clear 0, 0, 0
    BulletManager\draw!
    love.graphics.setCanvas!

  update: (dt) =>
    BulletManager\update(dt)
