local LCS = require("LuaCanSound")
local Synth
do
  local _class_0
  local env, generator_cache, cache
  local _base_0 = {
    load_gen = function(self, gen)
      if not generator_cache[gen] then
        generator_cache[gen] = LCS.generators[gen]:new()
      end
      return generator_cache[gen]
    end,
    generate = function(self, arg)
      local generator = self:load_gen(arg.gen)
      generator:start(arg.freq)
      env:start()
      local length = LCS.settings.sampleRate * arg.length
      local sample = love.sound.newSoundData(length, LCS.settings.sampleRate, 16, 1)
      for i = 0, length - 1 do
        sample:setSample(i, generator:tick() * env:tick() * 0.1)
      end
      return sample
    end,
    play = function(self, arg)
      arg.gen = arg.gen or "WhiteNoise"
      local arg_serialized = arg.gen .. ":" .. arg.freq .. ":" .. arg.length
      if not cache[arg_serialized] then
        cache[arg_serialized] = self:generate(arg)
      end
      return love.audio.play(love.audio.newSource(cache[arg_serialized]))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Synth"
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
  env = LCS.envelopes.ASR:new()
  generator_cache = { }
  cache = { }
  do
    local _with_0 = env
    _with_0:set({
      attack_seconds = 0.01
    })
    _with_0:set({
      sustain_seconds = 0.05
    })
    _with_0:set({
      decay_seconds = 0.01
    })
  end
  Synth = _class_0
end
return Synth()
