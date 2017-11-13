UI = require "lib.UI"
colorize = require "lib.colorize"

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
        button_world: {
          "button"
          left: 10, right: 10, top: 10, height: 20
          text: "Hello world"
          OnClick: =>
            cnv = UI.getWidget("DrawingArea")
            img = cnv\GetImage!
            love.graphics.setCanvas img
            colorize {math.random(1, 200), math.random(1, 200), math.random(1, 200)}, ->
              love.graphics.rectangle("fill", 0, 0, cnv\GetSize!)
            love.graphics.setCanvas!
        }
        inner_panel: {
          "panel"
          left: 0, right: 0, top: 100, height: 300
        }
      }
    }
  }
}

return layout
