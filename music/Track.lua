local love = love
local STATE_FADEIN = 1
local STATE_NORMAL = 2
local STATE_FADEOUT = 3
local STATE_FINAL = 4
local Track
do
  local _class_0
  local _base_0 = {
    set = function(self, args)
      for k, v in pairs(args) do
        self[k] = v
      end
      return self
    end,
    play = function(self, fadein)
      fadein = fadein or self.fadein
      self.started = true
      if not fadein or fadein == 0 then
        self.level = 1
        self.state = STATE_NORMAL
      else
        self.level = 0
        self.state = STATE_FADEIN
        self.fadein_speed = 1 / fadein
      end
      self.source:setVolume(self.level)
      return self.source:play()
    end,
    resume = function(self, fadein)
      fadein = fadein or self.fadein
      if not fadein or fadein == 0 then
        self.level = 1
        self.state = STATE_NORMAL
      else
        self.level = self.level or 0
        self.state = STATE_FADEIN
        self.fadein_speed = 1 / fadein
      end
      self.source:setVolume(self.level)
      if not self.started then
        return self.source:play()
      else
        return self.source:resume()
      end
    end,
    stop = function(self, fadeout)
      fadeout = fadeout or self.fadeout
      self.started = false
      if not fadeout or fadeout == 0 then
        self.state = STATE_FINAL
        self.level = 0
      else
        self.state = STATE_FADEOUT
        self.fadeout_speed = 1 / fadeout
        self.action = self.source.stop
      end
    end,
    pause = function(self, fadeout)
      fadeout = fadeout or self.fadeout
      if not fadeout or fadeout == 0 then
        self.state = STATE_FINAL
        self.level = 0
      else
        self.state = STATE_FADEOUT
        self.fadeout_speed = 1 / fadeout
        self.action = self.source.pause
      end
    end,
    update = function(self, dt)
      if self.state == STATE_FADEIN then
        self.level = self.level + (dt * self.fadein_speed)
      elseif self.state == STATE_FADEOUT then
        self.level = self.level - (dt * self.fadeout_speed)
      end
      if self.level < 0 then
        self.level = 0
        self.action(self.source)
      elseif self.level > 1 then
        self.level = 1
      end
      print(self.level)
      return self.source:setVolume(self.level)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, source)
      assert(type(source) == "string")
      self.source = love.audio.newSource(source)
      self.started = false
    end,
    __base = _base_0,
    __name = "Track"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Track = _class_0
end
return Track
