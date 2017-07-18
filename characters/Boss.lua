local vector = require("hump.vector")
local signal = require("hump.signal")
local lovelog = require("lib.lovelog")
local config = require("config")
local Bullet
Bullet = require("lib.Bullet").Bullet
local graphics, keyboard
do
  local _obj_0 = love
  graphics, keyboard = _obj_0.graphics, _obj_0.keyboard
end
local Vector = require("hump.vector")
local Basechar = require("lib.Basechar")
local HC = require("HCWorld")
local Enemy
do
  local _class_0
  local _parent_0 = Basechar
  local _base_0 = {
    circleBulletsTimer = function(self)
      print(self.circle_bullets_dt)
      if self.circle_bullets_dt >= 0.5 then
        self.circle_bullets_dt = 0
        return self:spawnCircleBullets()
      end
    end,
    update = function(self, dt)
      self.circle_bullets_dt = self.circle_bullets_dt + dt
      self:circleBulletsTimer()
      local vec = vector(0)
      if math.random() > 0.99 then
        self.mode = (self.mode == "right") and "left" or "right"
        self.text = self.texts[self.mode]
      end
      if math.random() > 0.96 then
        self:shoot()
      end
      if self.mode == "left" then
        vec.x = -1
      else
        vec.x = 1
      end
      self.pos = self.pos + dt * self.speed * vec:normalized()
      if self.pos.x < 0 then
        self.pos.x = 0
        self.mode = 'right'
      elseif self.pos.x > config.scene_width then
        self.pos.x = config.scene_width
        self.mode = 'left'
      end
      if next(HC:collisions(self.hitbox)) then
        for k, v in pairs(HC:collisions(self.hitbox)) do
          if k.type == "good" then
            self.hp = self.hp - 1
            signal.emit("boss_hp", self.max_hp, self.hp)
            if self.hp == 0 then
              signal.emit("Stage1_end")
            end
          end
        end
      end
      return self.hitbox:moveTo(self.pos.x, self.pos.y)
    end,
    bullet1 = function(self, x, y)
      local bullet = Bullet({
        pos = Vector(x, y),
        speed = math.random(30, 200),
        dir = Vector(math.random() - 0.5, math.random()):normalized(),
        char = "9",
        type = "evil"
      })
      bullet.update = function(self, dt)
        self.pos = self.pos + (self.speed * dt * self.dir)
        self.hitbox:moveTo(self.pos.x, self.pos.y)
        if self.pos.y < 0 or self.pos.y > love.graphics.getHeight() or self.pos.x < 0 or self.pos.x > config.scene_width then
          return self:remove()
        end
      end
    end,
    bullet2 = function(self, cx, cy, r, a)
      local bullet = Bullet({
        pos = Vector(cx, cy) + vector.fromPolar(a, r),
        speed = 40,
        char = "*",
        type = "evil"
      })
      bullet.r_vector = vector.fromPolar(a, r)
      bullet.center_pos = Vector(cx, cy)
      bullet.angle = a
      bullet.anglespeed = 1
      bullet.update = function(self, dt)
        print(self.r_vector)
        self.r_vector = self.r_vector:rotated(self.anglespeed * dt)
        self.angle = self.r_vector:toPolar()['x']
        self.r_vector = self.r_vector + (self.r_vector:normalized() * self.speed * dt)
        self.pos = self.center_pos + self.r_vector
        self.hitbox:moveTo(self.pos.x, self.pos.y)
        if self.pos.y > love.graphics.getHeight() then
          return self:remove()
        end
      end
    end,
    spawnCircleBullets = function(self)
      for i = 0, 19 do
        local a = i * 20 * (math.pi * 2) / 360
        self:bullet2(config.scene_width / 2, self.pos.y, 50, a)
      end
    end,
    shoot = function(self)
      return self:bullet1(self.pos.x, self.pos.y + 20)
    end,
    draw = function(self)
      _class_0.__parent.draw(self)
      return lovelog.print("Boss's hp: " .. self.hp)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, pos)
      self.hitbox_radius = 10
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.hitbox_radius)
      self.pos = pos or self.pos
      self.max_hp = 100
      self.hp = self.max_hp
      self.texts = {
        right = "(凸ಠ益ಠ)凸",
        left = "凸(ಠ益ಠ凸)"
      }
      self.mode = "right"
      self.text = [[(凸ಠ益ಠ)凸]]
      self.width = 100
      self.speed = 100
      self.circle_bullets_dt = 0
    end,
    __base = _base_0,
    __name = "Enemy",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Enemy = _class_0
  return _class_0
end
