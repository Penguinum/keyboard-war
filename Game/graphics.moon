const = require "const"

fontCache = {}

local graphics

loadFont = (name) ->
  paths = graphics.fonts[name]
  assert paths
  size = paths.size
  local font
  if not paths[1]
    font = love.graphics.newFont(size)
  else
    font = love.graphics.newFont(Game.GAME_PATH .. "/" .. paths[1], size)
  if paths[2]
    fallbacks = {}
    for i = 2, #paths
      table.insert fallbacks, love.graphics.newFont(Game.GAME_PATH .. "/" .. paths[i], size)
    font\setFallbacks unpack fallbacks
  return font

graphics =
  resize: ->
    screen_w, screen_h = unpack Game.settings.resolution
    love.window.setMode(screen_w, screen_h)
    canvas_max_w = screen_w - const.panel_width
    canvas_max_h = screen_h
    wh_ratio = canvas_max_w / canvas_max_h
    real_wh_ratio = const.scene_width / const.scene_height
    local scaling, space_is_vertical, space_is_horizontal
    if wh_ratio > real_wh_ratio
      scaling = canvas_max_h / const.scene_height
      space_is_horizontal = true
    else
      scaling = canvas_max_w / const.scene_width
      space_is_vertical = true
    const.scaling = scaling
    const.active_screen_width = math.floor(const.scene_width * scaling + const.panel_width)
    const.active_screen_height = math.floor(const.scene_height * scaling)
    if space_is_horizontal then
      const.hspace = math.floor((screen_w - const.active_screen_width) / 2)
      const.vspace = 0
    else
      const.vspace = math.floor((screen_h - const.active_screen_height) / 2)
      const.hspace = 0
    Game.scene\resize!

  fonts: {}
  setFont: (name) ->
    fontCache[name] = fontCache[name] or loadFont(name)
    love.graphics.setFont fontCache[name]
  getFontByName: (name) ->
    fontCache[name] = fontCache[name] or loadFont(name)
    return fontCache[name]

return graphics
