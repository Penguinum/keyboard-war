local colorize = require("lib.colorize")
local HC = require("HCWorld")
local BulletManager
BulletManager = require("lib.Bullet").BulletManager
local graphics
graphics = love.graphics
local BombManager = {
  size = 0,
  last = 0,
  bombs = { },
  addBomb = function(self, b)
    self.size = self.size + 1
    self.bombs[b] = true
  end,
  removeBomb = function(self, b)
    self.bombs[b] = nil
    self.size = self.size - 1
  end,
  update = function(self, dt)
    for b, _ in pairs(self.bombs) do
      if b.lifetime > b.max_lifetime then
        b:remove()
      end
      b:update(dt)
    end
  end,
  draw = function(self)
    for b, _ in pairs(self.bombs) do
      b:draw()
    end
  end,
  removeAllBombs = function(self)
    for b, _ in pairs(self.bombs) do
      b:remove()
    end
  end
}
local Bomb
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      self.lifetime = self.lifetime + dt
      if next(HC:collisions(self.hitbox)) then
        for k, v in pairs(HC:collisions(self.hitbox)) do
          if k.type == "evil" then
            print("EVILBOOLET", k)
            BulletManager:removeBulletWithHitbox(k)
          end
        end
      end
    end,
    draw = function(self)
      return colorize(self.color, function()
        return graphics.circle("line", self.pos.x, self.pos.y, self.rad)
      end)
    end,
    remove = function(self)
      HC:remove(self.hitbox)
      return BombManager:removeBomb(self)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, args)
      self.pos = args.pos
      self.rad = args.rad
      self.hitbox = HC:circle(self.pos.x, self.pos.y, self.rad)
      self.lifetime = 0
      self.max_lifetime = args.lifetime or 0
      self.color = {
        0,
        0,
        255
      }
      return BombManager:addBomb(self)
    end,
    __base = _base_0,
    __name = "Bomb"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Bomb = _class_0
end
return {
  BombManager = BombManager,
  Bomb = Bomb
}
