UI = require "lib.UI"

class LevelEditor
  new: =>
    (UI.panel {
      top: 0, bottom: 0, right: 0, width: 200
      button_hello: UI.button {
        left: 10, right: 10, bottom: 10, height: 20
        text: "Hello void"
        OnClick: =>
          UI.alert("Don't click hellovoids please")
      }
      button_world: UI.button {
        left: 10, right: 10, top: 10, height: 20
        text: "Hello world"
      }
      subpanel: UI.panel {
        left: 0, right: 0
        top: 50, height: 100
        button_sometext: UI.button {
          left: 0, right: 0, top: 0, height: 25,
          text: "Some text here"
        }
      }
    })!

  draw: =>
    UI.draw!

  update: (dt) =>
    UI.update dt

  mousepressed: (x, y, button) =>
    UI.mousepressed(x, y, button)

  mousereleased: (x, y, button) =>
    UI.mousereleased(x, y, button)

  textinput: (text) =>
    UI.textinput(text)

  keypressed: (key, unicode) =>
    UI.keypressed(key, unicode)
