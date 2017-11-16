local moon = require "moonyscript"
moon.insert_loader()

local StateManager = require "lib.StateManager"
local SceneManager = require "lib.SceneManager"
local MusicManager = require "lib.MusicPlayer"
local Controller = require "lib.Controller"

-- Lovedebug
-- require "lib.lovedebug"
_lovedebugpresskey = "~" -- luacheck: ignore
_G.StateManager = StateManager
_G.inspect = require "lib.inspect"

local lovelog = require "lib.lovelog"
local config = require "config"
local const = require "const"

local function getCanvasSize()
  local canvas_max_w = config.screen_width - const.panel_width
  local canvas_max_h = config.screen_height
  local wh_ratio = canvas_max_w / canvas_max_h
  local real_wh_ratio = const.scene_width / const.scene_height
  local scaling
  if wh_ratio > real_wh_ratio then
    scaling = canvas_max_h / const.scene_height
  else
    scaling = canvas_max_w / const.scene_width
  end
  const.scaling = scaling
  const.active_screen_width = math.floor(const.scene_width * scaling + const.panel_width)
  const.active_screen_height = math.floor(const.scene_height * scaling)
end

function love.load()
  love.window.setTitle("Keyboard wars")
  math.randomseed(os.time())
  if arg[#arg] == "-debug" then
    require("moddebug").start()
  end
  StateManager.switch{ screen = "MainMenu" }

  love.window.setMode(config.screen_width, config.screen_height)
  local canvas_w, canvas_h = getCanvasSize()
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

function love.mousepressed(x, y, button)
  local state = StateManager.getState()
  if state.mousepressed then
    state:mousepressed(x, y, button)
  end
end

function love.mousereleased(x, y, button)
  local state = StateManager.getState()
  if state.mousereleased then
    state:mousereleased(x, y, button)
  end
end

function love.textinput(text)
  local state = StateManager.getState()
  if state.textinput then
    state:textinput(text)
  end
end

function love.draw()
  if config.settings.graphics then
    local scene = StateManager:getState()
    if scene then
      scene:draw()
    end
  end
end

love.errhand = require "util.errhand"
