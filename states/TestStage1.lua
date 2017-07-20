local SceneManager = require("lib.SceneManager")
local StateManager = require("lib.StateManager")
local MusicManager = require("music.Manager")
local Track = require("music.Track")
local Vector = require("hump.vector")
local Bullet
Bullet = require("lib.Bullet").Bullet
local lovelog = require("lib.lovelog")
local config = require("config")
local enemies = {
  simple1 = {
    pos = Vector(5, 10),
    move = function(self, dt)
      self.pos = self.pos + 200 * Vector(1, 1) * dt
    end,
    shoot = function(self)
      if math.random() > 0.9 then
        return Bullet({
          pos = self.pos + Vector(0, 10),
          speed = math.random(50, 100),
          dir = Vector(0.2 * (math.random() - 0.5), math.random()):normalized(),
          char = "*"
        })
      end
    end
  },
  simple2 = {
    pos = Vector(595, 10),
    move = function(self, dt)
      self.pos = self.pos + 200 * Vector(-1, 1) * dt
    end,
    shoot = function(self)
      if math.random() > 0.9 then
        return Bullet({
          pos = self.pos + Vector(0, 10),
          speed = math.random(50, 100),
          dir = Vector(0.2 * (math.random() - 0.5), math.random()):normalized(),
          char = "*"
        })
      end
    end
  },
  challenging1 = {
    pos = Vector(5, 10),
    text = "(・`ω´・)",
    width = 60,
    move = function(self, dt)
      self.pos = self.pos + 200 * Vector(1, 1) * dt
    end,
    shoot = function(self)
      return Bullet({
        pos = self.pos + Vector(0, 10),
        speed = math.random(50, 100),
        dir = Vector(0.2 * (math.random() - 0.5), math.random()):normalized(),
        char = "*"
      })
    end
  },
  challenging2 = {
    pos = Vector(595, 10),
    text = "(・`ω´・)",
    width = 60,
    move = function(self, dt)
      self.pos = self.pos + 200 * Vector(-1, 1) * dt
    end,
    shoot = function(self)
      return Bullet({
        pos = self.pos + Vector(0, 10),
        speed = math.random(50, 100),
        dir = Vector(0.2 * (math.random() - 0.5), math.random()):normalized(),
        char = "*"
      })
    end
  }
}
local events = {
  {
    time = 0,
    action = function()
      SceneManager:spawnEnemy(enemies.simple1)
      return SceneManager:spawnEnemy(enemies.simple2)
    end
  },
  {
    time = 2,
    action = function()
      SceneManager:spawnEnemy(enemies.challenging1)
      return SceneManager:spawnEnemy(enemies.challenging2)
    end
  },
  {
    time = 3,
    action = function()
      SceneManager:spawnEnemy({
        pos = Vector(0, 30),
        text = "(╬`益´)",
        width = 60,
        move = function(self, dt)
          self.pos = self.pos + 500 * Vector(1, 0) * dt
        end,
        shoot = function(self)
          for i = 1, 3 do
            Bullet({
              pos = self.pos + Vector(0, 20 * i),
              speed = 400,
              dir = Vector(0, 1),
              char = "*"
            })
          end
        end
      })
      return SceneManager:spawnEnemy({
        pos = Vector(570, 30),
        text = "(`益´╬)",
        width = 60,
        move = function(self, dt)
          self.pos = self.pos + 500 * Vector(-1, 0) * dt
        end,
        shoot = function(self)
          for i = 1, 3 do
            Bullet({
              pos = self.pos + Vector(0, 20 * i),
              speed = 400,
              dir = Vector(0, 1),
              char = "*"
            })
          end
        end
      })
    end
  },
  {
    time = 3.1,
    action = function()
      SceneManager:spawnEnemy(enemies.challenging1)
      return SceneManager:spawnEnemy(enemies.challenging2)
    end
  },
  {
    time = 4,
    action = function()
      SceneManager:spawnEnemy({
        pos = Vector(30, -10),
        text = "(╬`益´)",
        width = 60,
        move = function(self, dt)
          self.pos = self.pos + 50 * Vector(0, 1) * dt
        end,
        shoot = function(self)
          for i = 1, 3 do
            Bullet({
              pos = self.pos + Vector(20 * i, 0),
              speed = 400,
              dir = Vector(1, 0),
              char = "*"
            })
          end
        end
      })
      return SceneManager:spawnEnemy({
        pos = Vector(570, -10),
        text = "(`益´╬)",
        width = 60,
        move = function(self, dt)
          self.pos = self.pos + 50 * Vector(0, 1) * dt
        end,
        shoot = function(self)
          for i = 1, 3 do
            Bullet({
              pos = self.pos - Vector(20 * i, 0),
              speed = 400,
              dir = Vector(-1, 0),
              char = "*"
            })
          end
        end
      })
    end
  },
  {
    time = 5,
    action = function()
      SceneManager:spawnEnemy({
        pos = Vector(30, -10),
        text = "(╬`益´)",
        width = 60,
        move = function(self, dt)
          self.pos = self.pos + 500 * Vector(0, 1) * dt
        end,
        shoot = function(self)
          return Bullet({
            pos = self.pos + Vector(10, 0),
            speed = 400,
            dir = Vector(1, 0),
            char = "*"
          })
        end
      })
      return SceneManager:spawnEnemy({
        pos = Vector(570, -10),
        text = "(`益´╬)",
        width = 60,
        move = function(self, dt)
          self.pos = self.pos + 500 * Vector(0, 1) * dt
        end,
        shoot = function(self)
          return Bullet({
            pos = self.pos - Vector(10, 0),
            speed = 400,
            dir = Vector(-1, 0),
            char = "*"
          })
        end
      })
    end
  },
  {
    time = 10,
    action = function()
      return SceneManager:spawnBoss({
        pos = Vector(0.5, 0.05),
        income_pos = Vector(0.5, -0.05)
      })
    end
  }
}
local Stage1
do
  local _class_0
  local enemy, music
  local _base_0 = {
    events = events,
    enter = function(self)
      self.time = 0
      self.current_event = 1
      love.graphics.setFont(config.fonts.art)
      SceneManager:spawnPlayer(Vector(0.5, 0.9))
      return MusicManager.sendEventToTag({
        tag = "Stage1",
        event = "play"
      })
    end,
    update = function(self, dt)
      SceneManager:update(dt)
      self.time = self.time + dt
      local event = self.events[self.current_event]
      if event and self.time >= event.time then
        self.current_event = self.current_event + 1
        return event.action()
      end
    end,
    keypressed = function(self, key)
      if key == "escape" then
        MusicManager.sendEventToTag({
          tag = "Stage1",
          event = "pause"
        })
        return StateManager.pause("PauseMenu")
      end
    end,
    draw = function(self)
      lovelog.reset()
      SceneManager:draw()
      return lovelog.print("FPS: " .. love.timer.getFPS())
    end,
    leave = function(self)
      return MusicManager.sendEventToTag({
        tag = "Stage1",
        event = "stop"
      })
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      return MusicManager.addTrack({
        track = music,
        alias = "Stage1",
        tag = "Stage1"
      })
    end,
    __base = _base_0,
    __name = "Stage1"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  enemy = nil
  music = Track("music/Confusion.ogg"):set({
    fadein = 1,
    fadeout = 1
  })
  Stage1 = _class_0
  return _class_0
end
