fonts = require "resources.fonts"
StateManager = require "lib.StateManager"
colorize = require "lib.colorize"

menu = {
  { id: "retry", text: "Retry",
    action: -> StateManager.switch {stage: "TestStage1"}
  }
  { id: "mainmenu", text: "Return to main menu",
    action: -> StateManager.switch {screen: "MainMenu"}
  }
  { id: "exit", text: "Exit", action: -> love.event.quit(0)}
}

class GameOver
  menu: menu
  enter: =>
    @active_node = 1

  draw: =>
    love.graphics.setFont fonts.art_big
    love.graphics.printf "Game over ლ(ಠ_ಠ ლ)", 30, 50, 300
    love.graphics.setFont fonts.menu
    x, y = 30, 100
    for i = 1, #@menu
      colorize (i == @active_node) and {100, 255, 100} or {100, 100, 100}, ->
        love.graphics.printf @menu[i].text, x, y, 200
      y += 30

  update: =>

  keypressed: (key_id) =>
    if key_id == "down"
      @active_node += 1
      if @active_node > #@menu
        @active_node = 1
    elseif key_id == "up"
      @active_node -= 1
      if @active_node == 0
        @active_node = #@menu
    elseif key_id == "shoot"
      @menu[@active_node].action!
