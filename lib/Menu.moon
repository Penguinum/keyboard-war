colorize = require "lib.colorize"

class Menu
  new: (args) =>
    @active_node = 1
    @background = args.background
    @menu = args.menu

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
      if @menu[@active_node].action
        @menu[@active_node].action!
    elseif @menu[@active_node].keypressed
      @menu[@active_node]\keypressed key_id

  update: (dt) =>
    if @background
      @background\update dt

  draw: () =>
    if @background
      @background\draw!
    x, y = 30, 30
    for i = 1, #@menu
      Game.graphics.setFont "menu"
      colorize (i == @active_node) and {100, 255, 100} or {100, 100, 100}, ->
        text = @menu[i].text
        if not text
          text = @menu[i]\getText!
        love.graphics.printf text, x, y, 300
      y += 30
