Matrix = Game.modules["backgrounds.Matrix"]

menu = {
  { id: "dev sandbox", text: "Dev sandbox", action: -> Game.state.switch {
      stage: "Sandbox"
    }
  }
  -- { id: "play", text: "Play", action: -> Game.state.switch {
  --     stage: "TestStage1"
  --   }
  -- }
  { id: "settings", text: "Settings", action: -> Game.state.switch {
      screen: "Settings"
    }
  }
  { id: "exit", text: "Exit", action: -> Game.quit(0) }
}

MainMenu = Menu
  menu: menu
  background: Matrix

return MainMenu
