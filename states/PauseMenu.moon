config = require "config"
StateManager = require "lib.StateManager"
SceneManager = require "lib.SceneManager"
MusicManager = require "music.Manager"
colorize = require "lib.colorize"

menu = {
  {
    id: "continue", text: "Continue"
    action: ->
      MusicManager.sendEventToTag {tag:"Stage1", event:"resume"}
      StateManager.resume!
  }
  {
    id: "mainmenu", text: "Return to main menu"
    action: ->
      SceneManager.clear!
      StateManager.switch "MainMenu"
  }
  { id: "exit", text: "Exit", action: -> love.event.quit(0)}
}

class PauseMenu
  menu: menu
  enter: =>
    @active_node = 1

  draw: =>
    love.graphics.setFont config.fonts.art_big
    love.graphics.printf "Paused (　’ω’)旦~~", 30, 50, 300
    love.graphics.setFont config.fonts.menu
    x, y = 30, 100
    for i = 1, #@menu
      -- love.graphics.getFont()
      -- love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
      colorize (i == @active_node) and {100, 255, 100} or {100, 100, 100}, ->
        love.graphics.printf @menu[i].text, x, y, 200
      y += 30

  update: =>

  keypressed: (key_id) =>
    if key_id == "escape"
      MusicManager.sendEventToTag {tag:"Stage1", event:"resume"}
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
