LF = require "LoveFrames"
unpack = unpack or table.unpack

WidgetConstructor = (func) ->
  setmetatable {widget: true}, {__call: ((frame) => func frame)}

isWidgetConstructor = (obj) ->
  return type(obj) == "table" and obj.widget

setSize = (obj, panel, args) ->
  local panel_w, panel_h
  if panel
    panel_w, panel_h = panel\GetSize!
  else
    panel_w, panel_h = love.graphics.getWidth!, love.graphics.getHeight!
  local left, width
  if not args.width
    left = args.left
    width = panel_w - args.right - args.left
  elseif not args.left
    left = panel_w - args.right - args.width
    width = args.width
  else
    left = args.left
    width = args.width
  local top, height
  if not args.height
    top = args.top
    height = panel_h - args.bottom - args.top
  elseif not args.top
    top = panel_h - args.bottom - args.height
    height = args.height
  else
    top = args.top
    height = args.height
  obj\SetPos(left, top)
  obj\SetSize(width, height)

UI =
  panel: (args) ->
    WidgetConstructor (frame) ->
      panel = LF.Create("panel", frame)
      setSize(panel, frame, args)
      for k, obj in pairs(args)
        if isWidgetConstructor obj
          panel[k] = obj panel

  button: (args) ->
    WidgetConstructor (frame) ->
      button = LF.Create("button", frame)
      setSize(button, frame, args)
      button\SetText(args.text)
      button.OnClick = args.OnClick
      return button

  alert: (message) ->
    frame = LF.Create("frame")
    frame\SetModal(true)
    frame\SetSize(400, 200)
    text = LF.Create("text", frame)
    text\SetText(message)
    text\SetPos(10, 30)
    text\SetSize(380, 140)
    button = LF.Create("button", frame)
    button\SetText("OK")
    button\SetPos(10, 170)
    button\SetSize(380, 20)
    button.OnClick = =>
      frame\Remove!
    frame\Center!

  draw: ->
    LF.draw!

  update: (dt) ->
    LF.update dt

  mousepressed: (x, y, button) ->
    LF.mousepressed(x, y, button)

  mousereleased: (x, y, button) ->
    LF.mousereleased(x, y, button)

  textinput: (text) ->
    LF.textinput(text)

  keypressed: (key, unicode) ->
    LF.keypressed(key, unicode)

return UI
