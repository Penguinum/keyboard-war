Widgets = require "lib.Widgets"
LF = require "LoveFrames"
unpack = unpack or table.unpack

widget_map = {}

local UI
UI =
  -- root is optional
  load: (current_widget_desc, root) ->
    local current_widget
    if Widgets[current_widget_desc[1]]
      current_widget = Widgets[current_widget_desc[1]] current_widget_desc, root
      if current_widget_desc.id
        widget_map[current_widget_desc.id] = current_widget
      if current_widget_desc.center
        current_widget\Center!
    if not current_widget_desc.content
      return
    for k, widget in pairs(current_widget_desc.content)
      UI.load widget, current_widget

  popup: (layout) ->
    UI.load layout

  loadForm: (id) ->
    full_name = "states.forms." .. id
    -- package.preload[id] = nil
    -- package.loaded[id] = nil
    return UI.load require full_name

  getWidget: (id) -> widget_map[id]

  inject: (obj) ->
    methods = {
      "draw", "update",
      "mousepressed", "mousereleased",
      "textinput", "keypressed"
    }
    for _, method in pairs methods
      obj[method] = (...) =>
        if LF[method]
          LF[method](...)

return UI
