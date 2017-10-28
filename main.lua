local moon = require "moonyscript"
moon.insert_loader()

local StateManager = require "lib.StateManager"
local SceneManager = require "lib.SceneManager"
local MusicManager = require "music.Manager"
local Controller = require "lib.Controller"
require "lib.lovedebug"

local lovelog = require "lib.lovelog"
local config = require "config"
lovelog.disable()

function love.load()
  love.window.setTitle("Keyboard wars")
  math.randomseed(os.time())
  if arg[#arg] == "-debug" then
    require("moddebug").start()
  end
  StateManager.switch("MainMenu")

  love.window.setMode(config.scene_width + config.panel_width, config.scene_height)
end

function love.update(dt)
  local scene = StateManager:getState()
  if scene then
    scene:update(dt)
  end
  MusicManager.update(dt)
end

function love.keypressed(key_id)
  if key_id == "f1" then
    lovelog.toggle()
  end
  local action_key = Controller.getActionByKey(key_id)
  SceneManager:keypressed(action_key, key_id)
end

function love.keyreleased(key_id)
  local action_key = Controller.getActionByKey(key_id)
  action_key = Controller.getActionByKey(key_id)
  SceneManager:keyreleased(action_key, key_id)
end

function love.draw()
  if config.settings.graphics then
    local scene = StateManager:getState()
    if scene then
      scene:draw()
    end
  end
end
