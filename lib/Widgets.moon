LF = require "LoveFrames"
colorize = require "lib.colorize"
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

panel = (args, frame) ->
  p = LF.Create("panel", frame)
  setSize(p, frame, args)
  return p

frame = (args) ->
  frame = LF.Create("frame")
  setSize(frame, nil, args)
  return frame

button = (args, frame) ->
  button = LF.Create("button", frame)
  setSize(button, frame, args)
  button\SetText(args.text)
  button.OnClick = args.OnClick
  return button

alert = (message) ->
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

popup = (content) ->
  frame = (frame {
    left: 0, right: 0, top: 0, bottom: 0, modal: true
  })!
  frame\SetModal(true)
  content(frame)

canvas = (args, frame) ->
  p = LF.Create("image", frame)
  setSize(p, frame, args)
  cnv = love.graphics.newCanvas(p\GetSize!)
  love.graphics.setCanvas(cnv)
  colorize {0, 0, 0}, ->
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth!, love.graphics.getHeight!)
  love.graphics.setCanvas!
  p\SetImage(cnv)
  return p

menu = (args) ->
  LF.Create("menu")


{
  :panel
  :button
  :alert
  :canvas
  :menu
}
