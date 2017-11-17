settings = Game.settings

return Menu
  menu: {
    {
      id: "res"
      resolutions: {{800, 600}, {900, 650}}
      keypressed: (key) =>
        if key ~= "left" and key ~= "right"
          return
        if not @current_resolution
          @current_resolution = #@resolutions
          res = settings.resolution
          for i, v in ipairs @resolutions
            if res[1] == v[1] and res[2] == v[2]
              @current_resolution = i
              break
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
