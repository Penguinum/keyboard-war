Menu
  menu: {
    caption: "Paused (　’ω’)旦~~"
    {
      id: "continue", text: "Continue"
      action: -> Game.state.resume!
    }
    {
      id: "mainmenu", text: "Return to main menu"
      action: ->
        Game.scene.clear!
        Game.state.switch {screen: "MainMenu"}
    }
    { id: "exit", text: "Exit", action: -> love.event.quit(0)}
  }
