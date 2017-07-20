local StateManager = require("lib.StateManager")
local SceneManager = require("lib.SceneManager")
local MusicManager = require("music.Manager")
local Controller = require("lib.Controller")
local lovelog = require("lib.lovelog")
lovelog.disable()
local config = require("config")
love.load = function()
  love.window.setTitle("Keyboard wars")
  math.randomseed(os.time())
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end
  StateManager.switch("MainMenu")
  return love.window.setMode(config.scene_width + config.panel_width, config.scene_height)
end
love.update = function(dt)
  local scene = StateManager:getState()
  if scene then
    scene:update(dt)
  end
  return MusicManager.update(dt)
end
love.keypressed = function(key_id)
  if key_id == "f1" then
    lovelog.toggle()
  end
  key_id = Controller.getActionByKey(key_id)
  return SceneManager:keypressed(key_id)
end
love.keyreleased = function(key_id)
  key_id = Controller.getActionByKey(key_id)
  return SceneManager:keyreleased(key_id)
end
love.draw = function()
  if not config.settings.graphics then
    return 
  end
  local scene = StateManager:getState()
  if scene then
    return scene:draw()
  end
end
