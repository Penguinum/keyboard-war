local moon = require "moonyscript"
moon.insert_loader()

local StateManager = require "lib.StateManager"
local SceneManager = require "lib.SceneManager"
local MusicManager = require "lib.MusicPlayer"
local Controller = require "lib.Controller"
local CScreen = require "lib.CScreen"

-- Lovedebug
-- require "lib.lovedebug"
_lovedebugpresskey = "~" -- luacheck: ignore
_G.StateManager = StateManager
_G.inspect = require "lib.inspect"

local lovelog = require "lib.lovelog"
local config = require "config"

function love.load()
  love.window.setTitle("Keyboard wars")
  math.randomseed(os.time())
  if arg[#arg] == "-debug" then
    require("moddebug").start()
  end
  StateManager.switch{ screen = "MainMenu" }

  love.window.setMode(config.screen_width, config.screen_height)
  CScreen.init(config.screen_width, config.screen_height, true)
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
  local state = StateManager.getState()
  if state.keypressed then
    state:keypressed(action_key, key_id)
  end
end

function love.keyreleased(key_id)
  local state = StateManager.getState()
  if state.keyreleased then
    local action_key = Controller.getActionByKey(key_id)
    action_key = Controller.getActionByKey(key_id)
    state:keyreleased(action_key, key_id)
  end
end

function love.draw()
  CScreen.apply()
  if config.settings.graphics then
    local scene = StateManager:getState()
    if scene then
      scene:draw()
    end
  end
  CScreen.cease()
end
