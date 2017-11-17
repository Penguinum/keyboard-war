Controller = require "lib.Controller"
StateManager = require "lib.StateManager"

love.draw = ->
  if Game.settings.graphics
    scene = StateManager\getState!
    if scene
      scene\draw()

love.keypressed = (key_id) ->
  action_key = Controller.getActionByKey(key_id)
  state = StateManager.getState!
  if state.keypressed
    state\keypressed(action_key, key_id)

love.keyreleased = (key_id) ->
  state = StateManager.getState!
  if state.keyreleased then
    action_key = Controller.getActionByKey(key_id)
    action_key = Controller.getActionByKey(key_id)
    state\keyreleased(action_key, key_id)

love.mousepressed = (x, y, button) ->
  state = StateManager.getState!
  if state.mousepressed then
    state\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
  state = StateManager.getState!
  if state.mousereleased then
    state\mousereleased(x, y, button)

love.textinput = (text) ->
  state = StateManager.getState!
  if state.textinput then
    state\textinput(text)

love.load = () ->
  love.window.setTitle("Keyboard wars")
  math.randomseed(os.time())
  if arg[#arg] == "-debug"
    require("moddebug").start()

  love.window.setMode(unpack(Game.settings.resolution))
  Game.graphics.resize!

love.update = (dt) ->
  scene = StateManager\getState()
  if scene then
    scene\update(dt)
  Game.music\update(dt)

require(Game.GAME_PATH .. "/init")
