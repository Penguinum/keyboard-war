local config = require("config")
local StateManager = require("lib.StateManager")
local SceneManager = require("lib.SceneManager")
local MusicManager = require("music.Manager")
local colorize = require("lib.colorize")
local menu = {
  {
    id = "continue",
    text = "Continue",
    action = function()
      MusicManager.sendEventToTag({
        tag = "Stage1",
        event = "resume"
      })
      return StateManager.resume()
    end
  },
  {
    id = "mainmenu",
    text = "Return to main menu",
    action = function()
      SceneManager.clear()
      MusicManager.sendEventToTag({
        tag = "Stage1",
        event = "stop"
      })
      return StateManager.switch("MainMenu")
    end
  },
  {
    id = "exit",
    text = "Exit",
    action = function()
      return love.event.quit(0)
    end
  }
}
local PauseMenu
do
  local _class_0
  local _base_0 = {
    menu = menu,
    enter = function(self)
      self.active_node = 1
    end,
    draw = function(self)
      love.graphics.setFont(config.fonts.art_big)
      love.graphics.printf("Paused (　’ω’)旦~~", 30, 50, 300)
      love.graphics.setFont(config.fonts.menu)
      local x, y = 30, 100
      for i = 1, #self.menu do
        colorize((i == self.active_node) and {
          100,
          255,
          100
        } or {
          100,
          100,
          100
        }, function()
          return love.graphics.printf(self.menu[i].text, x, y, 200)
        end)
        y = y + 30
      end
    end,
    update = function(self) end,
    keypressed = function(self, key_id)
      if key_id == "escape" then
        MusicManager.sendEventToTag({
          tag = "Stage1",
          event = "resume"
        })
        return StateManager.resume()
      elseif key_id == "down" then
        self.active_node = self.active_node + 1
        if self.active_node > #self.menu then
          self.active_node = 1
        end
      elseif key_id == "up" then
        self.active_node = self.active_node - 1
        if self.active_node == 0 then
          self.active_node = #self.menu
        end
      elseif key_id == "shoot" then
        return self.menu[self.active_node].action()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "PauseMenu"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  PauseMenu = _class_0
  return _class_0
end
