StateManager = require "lib.StateManager"
SceneManager = require "lib.SceneManager"
MusicPlayer = require "lib.MusicPlayer"
colorize = require "lib.colorize"
fonts = require "resources.fonts"

menu = {
  {
    id: "continue", text: "Continue"
    action: ->
      StateManager.resume!
  }
  {
    id: "mainmenu", text: "Return to main menu"
    action: ->
      SceneManager.clear!
      StateManager.switch {screen: "MainMenu"}
  }
  { id: "exit", text: "Exit", action: -> love.event.quit(0)}
}

class PauseMenu
  menu: menu
  enter: =>
    @active_node = 1

  draw: =>
    love.graphics.setFont fonts.art_big
    love.graphics.printf "Paused (　’ω’)旦~~", 30, 50, 300
    love.graphics.setFont fonts.menu
    x, y = 30, 100
    for i = 1, #@menu
      colorize (i == @active_node) and {100, 255, 100} or {100, 100, 100}, ->
        love.graphics.printf @menu[i].text, x, y, 200
      y += 30

  update: =>

  keypressed: (key_id) =>
    if key_id == "escape"
      MusicPlayer.sendEventToTag {tag:"Stage1", event:"resume"}
      StateManager.resume!
    elseif key_id == "down"
      @active_node += 1
      if @active_node > #@menu
        @active_node = 1
    elseif key_id == "up"
      @active_node -= 1
      if @active_node == 0
        @active_node = #@menu
    elseif key_id == "shoot"
      @menu[@active_node].action!
