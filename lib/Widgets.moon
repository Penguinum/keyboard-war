LF = require "LoveFrames"
colorize = require "util.colorize"
unpack = unpack or table.unpack

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
  elseif not args.left and args.right
    left = panel_w - args.right - args.width
    width = args.width
  else
    left = args.left
    width = args.width
  local top, height
  if not args.height
    top = args.top
    height = panel_h - args.bottom - args.top
  elseif not args.top and args.bottom
    top = panel_h - args.bottom - args.height
    height = args.height
  else
    top = args.top
    height = args.height
  obj\SetPos(left, top)
  obj\SetSize(width, height)

panel = (args, parent) ->
  p = LF.Create("panel", parent)
  setSize(p, parent, args)
  return p

frame = (args) ->
  obj = LF.Create("frame")
  setSize(obj, nil, args)
  return obj

button = (args, parent) ->
  obj = LF.Create("button", parent)
  setSize(obj, parent, args)
  obj\SetText(args.text)
  obj.OnClick = args.OnClick
  return obj

text = (args, parent) ->
  obj = LF.Create("text", parent)
  setSize(obj, parent, args)
  obj\SetText(args.text)
  return obj

list = (args, parent) ->
  obj = LF.Create("list", parent)
  setSize(obj, parent, args)
  obj.OnSelect = args.OnSelect
  if args.items
    for _, item in ipairs(args.items)
      b = LF.Create("button")
      b\SetText(item)
      b.OnClick = =>
        if obj.OnSelect
          obj\OnSelect item
      obj\AddItem(b)
  return obj

alert = (message) ->
  _frame = LF.Create("frame")
  _frame\SetModal(true)
  _frame\SetSize(400, 200)
  text = LF.Create("text", _frame)
  text\SetText(message)
  text\SetPos(10, 30)
  text\SetSize(380, 140)
  button = LF.Create("button", _frame)
  button\SetText("OK")
  button\SetPos(10, 170)
  button\SetSize(380, 20)
  button.OnClick = =>
    _frame\Remove!
  _frame\Center!

slider = (args, parent) ->
  obj = LF.Create("slider", parent)
  setSize(obj, parent, args)
  obj\SetMax(args.max)
  obj\SetMin(args.min)
  obj\SetSlideType(args.slidetype)
  if args.default
    obj\SetValue(args.default)
  obj.OnValueChanged = args.OnValueChanged
  return obj

canvas = (args, parent) ->
  p = LF.Create("image", parent)
  setSize(p, parent, args)
  cnv = love.graphics.newCanvas(p\GetSize!)
  love.graphics.setCanvas(cnv)
  colorize {0, 0, 0}, ->
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth!, love.graphics.getHeight!)
  love.graphics.setCanvas!
  p\SetImage(cnv)
  return p

colorpicker = (args, parent) ->
  obj = LF.Create("panel", parent)
  setSize(obj, parent, args)
  color = args.default or {0, 0, 0}
  _, self_h = obj\GetSize!
  cnv = canvas({right: 0, width: self_h, top: 0, bottom: 0}, obj)
  redraw = ->
    love.graphics.setCanvas cnv\GetImage!
    love.graphics.clear unpack color
    love.graphics.setCanvas!
  for i = 1, 3
    slider({
      left: 2, right: self_h + 2,
      top: (i - 1) * (3 * self_h / 8 - 1), height: self_h / 4
      min: 0, max: 255, default: color[i]
      slidetype: "horizontal"
      OnValueChanged: (value) =>
        color[i] = math.floor(value)
        redraw!
    }, obj)


menu = (args) ->
  LF.Create("menu")


{
  :panel
  :frame
  :button
  :text
  :slider
  :colorpicker
  :list
  :alert
  :canvas
  :menu
}
