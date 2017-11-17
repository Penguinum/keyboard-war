settings = Game.settings

return Menu
  menu: {
    {
      id: "res"
      resolutions: {{800, 600}, {900, 650}}
      keypressed: (key) =>
        if not @current_resolution
          @current_resolution = 1
        @current_resolution += 1
        if @current_resolution > #@resolutions
          @current_resolution = 1
        settings.resolution = @resolutions[@current_resolution]
        Game.graphics.resize!
      getText: =>
        return "Resolution: " .. (settings.resolution[1] .. "x" .. settings.resolution[2])
    }
    { -- Just kidding
      id: "gfx"
      keypressed: (key) =>
        if key == "left" or key == "right"
          settings.graphics = not settings.graphics
      getText: =>
        return "Graphics: " .. (settings.graphics and "on" or "off")
      }
    {
      id: "back"
      text: "Back"
      action: => Game.state.switch { screen: "MainMenu" }
    }
  }
