do
local _ENV = _ENV
package.preload[ "ADSR" ] = function( ... ) local arg = _G.arg;
local ADSR = {}; ADSR.__index = ADSR
local Settings = require "settings"

local ATTACK = 1
local DECAY = 2
local SUSTAIN = 3
local RELEASE = 4
local FINAL = 5

function ADSR:new(a, d, s, r)
  assert(a >= 0)
  assert(d >= 0)
  assert(s >= 0 and s <= 1)
  assert(r >= 0)
  local adsr = {
    state = 1,
    sample_num = 1,
    state_sample_num = 1,
    sample_value = 0,
    value_delta = 0,
    attack = a * Settings.sampleRate,
    decay = d * Settings.sampleRate,
    sustain = s,
    release = r * Settings.sampleRate,
  }
  return setmetatable(adsr, ADSR)
end

function ADSR:setADSR(a, d, s, r)
  print(a, d, s, r)
  assert(a >= 0)
  assert(d >= 0)
  assert(s >= 0 and s <= 1)
  assert(r >= 0)
  self.attack = a * Settings.sampleRate
  self.decay = d * Settings.sampleRate
  self.sustain = s
  self.release = r * Settings.sampleRate
  return self
end

function ADSR:start()
  self.sample_num = 1
  self.state = ATTACK
  self.current_sample = 1
  self.last_value = 0
  self.active = true
  return self
end

function ADSR:stopSustain()
  if self.state < RELEASE then
    self.release_max = self.last_value
    self.current_sample = 0
  end
  self.state = RELEASE
  return self
end

function ADSR:stop()
  self.state = FINAL
end

function ADSR:tick()
  if not self.active then
    return 0
  end
  local cur_state = self.state
  if cur_state == ATTACK then
    if self.attack == 0 then
      self.state = DECAY
    else
      self.last_value = self.current_sample / self.attack
      if self.current_sample >= self.attack then
        self.state = DECAY
        self.current_sample = 1
      end
      self.current_sample = self.current_sample + 1
      return self.last_value
    end
  end
  if cur_state == DECAY then
    if self.decay == 0 then
      self.state = self.state + 1
    else
      self.last_value = 1 - (1 - self.sustain) * self.current_sample / self.decay
      if self.current_sample >= self.decay then
        self.state = self.state + 1
        self.current_sample = 0
      end
      self.current_sample = self.current_sample + 1
      return self.last_value
    end
  end
  if cur_state == SUSTAIN then
    self.last_value = self.sustain
    return self.last_value
  end
  if cur_state == RELEASE then
    if self.release == 0 then
      self.last_value = 0
      self.state = FINAL
    else
      self.last_value = self.release_max - self.release_max * self.current_sample / self.release
      if self.current_sample >= self.release then
        self.state = FINAL
        self.active = false
      end
      self.current_sample = self.current_sample + 1
      return self.last_value
    end
  end
  return 0
end

return ADSR

end
end

do
local _ENV = _ENV
package.preload[ "Square" ] = function( ... ) local arg = _G.arg;
local settings = require "settings"
local Square = require("generator")()

local M_PI = math.pi
local TWO_M_PI = 2 * M_PI
local sampleRate = settings.sampleRate

Square.properties = {
  frequency = 200,
}

function Square:new()
  local gen = {
    phase = 0,
    phase_delta = 0,
    active = false,
    width = 0.5
  }
  return setmetatable(gen, Square)
end

function Square:start(frequency)
  assert(frequency > 0)
  self.sample_num = 0
  self.phase_delta = frequency * TWO_M_PI / sampleRate
  self.phase = 0
  self.active = true
  return self
end

function Square:tick()
  if not self.active then return 0 end
  local phase = self.phase
  if phase >= TWO_M_PI then
    phase = phase - TWO_M_PI
  end
  self.phase = phase + self.phase_delta
  return (phase < M_PI) and 1 or -1
end

return Square

end
end

do
local _ENV = _ENV
package.preload[ "ASR" ] = function( ... ) local arg = _G.arg;
-- Simple envelope: attack and release

local ASR = require("envelope")()
local sampleRate = require("settings").sampleRate

ASR.parameters = {
  attack_seconds = {
    value = 0,
    set = function(obj, value)
      obj.attack_seconds = value
      obj.attack_samples = value * sampleRate
    end
  },
  attack_samples = {
    set = function(obj, value)
      obj.attack_samples = value
      obj.attack_seconds = value / sampleRate
    end
  },
  -- Sustain time, not level
  sustain_seconds = {
    value = 1,
    set = function(obj, value)
      obj.sustain_seconds = value
      obj.sustain_samples = value * sampleRate
    end
  },
  sustain_samples = {
    set = function(obj, value)
      obj.sustain_samples = value
      obj.sustain_seconds = value / sampleRate
    end
  },
  release_seconds = {
    value = 0,
    set = function(obj, value)
      obj.release_seconds = value
      obj.release_samples = value * sampleRate
    end
  },
  release_samples = {
    set = function(obj, value)
      obj.release_samples = value
      obj.release_seconds = value / sampleRate
    end
  },
}

function ASR:new()
  local ar = {
    last_value = 0
  }
  return setmetatable(ar, ASR):initDefaults()
end

function ASR:start()
  self.attack_samples_left = self.attack_samples
  self.sustain_samples_left = self.sustain_samples or 0
  self.release_samples_left = self.release_samples or 0
  self.last_value = 0
  if self.attack_samples_left > 0 then
    self.attack_delta = 1 / self.attack_samples_left
  end
  if self.release_samples_left > 0 then
    self.release_delta = -1 / self.release_samples_left
  end
  self.tick = self.__tickAttack
  return self
end

function ASR:__tickAttack(gen)
  if self.attack_samples_left <= 0 then
    self.tick = ASR.__tickSustain
    self.last_value = 1
    return self:tick()
  end
  self.last_value = self.last_value + self.attack_delta
  self.attack_samples_left = self.attack_samples_left - 1
  if gen then
    return self.last_value * gen:tick()
  end
  return self.last_value
end

function ASR:__tickSustain(gen)
  if self.sustain_samples_left <= 0 then
    self.tick = ASR.__tickRelease
    return self:tick()
  end
  self.sustain_samples_left = self.sustain_samples_left - 1
  if gen then
    return gen:tick()
  end
  return 1
end

function ASR:__tickRelease(gen)
  if self.release_samples_left <= 0 then
    self.tick = ASR.__tickFinal
    return self:tick()
  end
  self.last_value = self.last_value + self.release_delta
  self.release_samples_left = self.release_samples_left - 1
  if gen then
    return self.last_value * gen:tick()
  end
  return self.last_value
end

function ASR:__tickFinal()
  return 0
end

return ASR

end
end

do
local _ENV = _ENV
package.preload[ "LuaCanSound_init" ] = function( ... ) local arg = _G.arg;
local package_table = {
  generators = {
    Sine = require "Sine",
    Square = require "Square",
    Triangle = require "Triangle",
    WhiteNoise = require "WhiteNoise",
    KarplusStrong = require "KarplusStrong",
  },
  filters = {
    Delay = require "Delay",
    Lowpass = require "Lowpass",
    KarplusStrongFilter = require "KarplusStrongFilter",
  },
  envelopes = {
    ASR = require "ASR",
    ADSR = require "ADSR",
  },
  base = {
    generator = require "generator",
    envelope = require "envelope",
  },
  settings = require "settings"
}

return package_table

end
end

do
local _ENV = _ENV
package.preload[ "WhiteNoise" ] = function( ... ) local arg = _G.arg;
local WhiteNoise = {}; WhiteNoise.__index = WhiteNoise

local random = math.random

function WhiteNoise:new()
  local gen = {
    active = false,
  }
  return setmetatable(gen, WhiteNoise)
end

function WhiteNoise:start()
  self.active = true
  return self
end

function WhiteNoise:tick()
  if not self.active then
    return 0
  end
  return random() * 2 - 1
end

return WhiteNoise

end
end

do
local _ENV = _ENV
package.preload[ "Triangle" ] = function( ... ) local arg = _G.arg;
local settings = require "settings"

local Triangle = require("generator")()
local M_PI = math.pi

function Triangle:new()
  local gen = {
    phase = 0,
    dt = 1,
    phase_delta = 0,
    active = false,
    width = 0.5
  }
  return setmetatable(gen, Triangle)
end

function Triangle:start(frequency)
  assert(frequency > 0)
  self.sample_num = 0
  self.dt = 1 / settings.sampleRate
  self.phase_delta = frequency * 2 * M_PI * self.dt
  self.w_up = M_PI * self.width
  self.w_down = M_PI * (1 - self.width)
  self.phase = 2 * M_PI - self.w_up
  self.active = true
  return self
end

function Triangle:tick()
  if not self.active then
    return 0
  end
  if self.phase >= 2 * M_PI then
    self.phase = self.phase - 2 * M_PI
  end
  local sample
  local w_up, w_down, phase = self.w_up, self.w_down, self.phase
  if w_down == 0 then
    sample = -1 + 1.0 / M_PI * phase
  else
    if phase < 2 * w_down then
      sample = 1 - phase / w_down
    else
      sample = -1 + (phase - 2 * w_down) / w_up
    end
  end
  self.phase = phase + self.phase_delta
  return sample
end

return Triangle

end
end

do
local _ENV = _ENV
package.preload[ "Lowpass" ] = function( ... ) local arg = _G.arg;
-- A prototype, work in progress
local ring = require "ring"

local LP = {}; LP.__index = LP

function LP:new()
  local lp = {
    buf = ring:new(10)
  }
  return setmetatable(lp, LP)
end

function LP:tick(new_sample)
  local buf = self.buf
  buf:apply(new_sample)
  local res = 0
  for i = 0, buf.size-1 do
    res = res + buf:atOffset(i)
  end
  return res/(1.0*buf.size)
end

function LP:clear() --TODO
  self.buf:fill(0)
end

return LP

end
end

do
local _ENV = _ENV
package.preload[ "ks_battery" ] = function( ... ) local arg = _G.arg;
local ks = require "ks_filter"

local KS_battery = {}
KS_battery.__index = KS_battery

function KS_battery:new(...)
  local filter = {
    filters = {},
  }
  for k, frequency in pairs{...} do
    filter.filters[k] = ks:new()
    filter.filters[k]:setFrequency(frequency)
  end
  return setmetatable(filter, KS_battery)
end

function KS_battery:clear()
  for k, v in pairs(self.filters) do
    v:clear()
  end
end

function KS_battery:tick(input)
  local output = 0
  for k, v in pairs(self.filters) do
    output = output + v:tick(input)
  end
  output = output / #self.filters
  return output
end

return KS_battery


end
end

do
local _ENV = _ENV
package.preload[ "Sine" ] = function( ... ) local arg = _G.arg;
local Sine = require("generator")()
local settings = require "settings"

local sin = math.sin
local TWO_PI = 2 * math.pi
local sampleRate = settings.sampleRate

Sine.properties = {
  frequency = 200,
}

function Sine:tick()
  if not self.active then return 0 end
  local phase = self.phase
  local value = sin(phase)
  self.phase = phase + self.phase_delta
  return value
end

function Sine:start(frequency)
  self.frequency = frequency
  self.active = true
  self.phase_delta = TWO_PI * frequency / sampleRate
  return self
end

function Sine:new()
  local gen = {
    phase = 0,
    phase_delta = 0,
    active = false,
  }
  return setmetatable(gen, Sine)
end

return Sine

end
end

do
local _ENV = _ENV
package.preload[ "settings" ] = function( ... ) local arg = _G.arg;
local settings = {
  sampleRate = 44100,
}
return settings

end
end

do
local _ENV = _ENV
package.preload[ "KarplusStrongFilter" ] = function( ... ) local arg = _G.arg;
local Delay = require "Delay"

local Ha = {}
Ha.__index = Ha

function Ha:new()
  local gen = {
    previous_sample = 0
  }
  return setmetatable(gen, Ha)
end

function Ha:tick(s)
  local result = (self.previous_sample + s) / 2.0
  self.previous_sample = s
  return result
end

function Ha:clear()
  self.previous_sample = 0
  return self
end

local KS_filter = {}
KS_filter.__index = KS_filter

function KS_filter:new()
  local gen = {
    ha_filter = Ha:new(),
    delay_filter = Delay:new(),
    frequency = 0,
    filtered_output = 0,
  }
  return setmetatable(gen, KS_filter)
end

function KS_filter:setFrequency(frequency)
  self.frequency = frequency
  local delay_line_length = 1.0 / frequency
  self.delay_filter:setLength(delay_line_length)
  return self
end

function KS_filter:clear()
  self.filtered_output = 0
  self.ha_filter:clear()
  self.delay_filter:clear()
end

function KS_filter:tick(input)
  local in_plus_filtered = input + self.filtered_output
  local output = self.delay_filter:tick(in_plus_filtered)*0.995
  self.filtered_output = self.ha_filter:tick(output)
  return output
end

return KS_filter

end
end

do
local _ENV = _ENV
package.preload[ "ring" ] = function( ... ) local arg = _G.arg;
local Ring = {}
Ring.__index = Ring

function Ring:new(size)
  local buf = {
    data = {},
    size = size,
    current_pos = 1,
  }
  return setmetatable(buf, Ring):fill(0)
end

function Ring:fill(value)
  for i = 1, self.size do
    self.data[i] = value
  end
  return self
end

function Ring:apply(sample)
  self.data[self.current_pos] = sample
  if self.current_pos == self.size then
    self.current_pos = 1
  else
    self.current_pos = self.current_pos + 1
  end
  return self
end

function Ring:atOffset(offset)
  local pos = self.current_pos + offset
  if pos < 1 then
    pos = pos + self.size
  elseif pos > self.size then
    pos = pos - self.size
  end
  return self.data[pos]
end

return Ring

end
end

do
local _ENV = _ENV
package.preload[ "envelope" ] = function( ... ) local arg = _G.arg;
local settings = require "settings"

local Env = {}

function Env:tick()
  return 0
end

function Env:start()
  self.active = true
  return self
end

function Env:set(param_table)
  local parameters = self.parameters
  for k, v in pairs(param_table) do
    if parameters[k] then
      if parameters[k].set then
        parameters[k].set(self, v)
      else
        self[k] = v
      end
    end
  end
  return self
end

function Env:initDefaults()
  for k, v in pairs(self.parameters) do
    if v.value then
      self:set{[k]=v.value}
    end
  end
  return self
end

function Env:stop()
  self.active = false
  return self
end

function Env:continue()
  self.active = true
  return self
end

function Env:generate(length_seconds)
  local length_samples = settings.sampleRate * length_seconds
  local sound_array = {}
  for i = 1, length_samples do
    sound_array[i] = self:tick()
  end
  return sound_array
end

local function Create()
  local new_class = {}
  local new_class_mt = {__index=Env}
  setmetatable(new_class, new_class_mt)
  new_class.__index = new_class
  return new_class
end

return Create

end
end

do
local _ENV = _ENV
package.preload[ "generator" ] = function( ... ) local arg = _G.arg;
local settings = require "settings"

local Gen = {}

function Gen:tick()
  return 0
end

function Gen:set(param_table)
  local parameters = self.parameters
  for k, v in pairs(param_table) do
    if parameters[k] then
      if parameters[k].set then
        parameters[k].set(self, v)
      else
        self[k] = v
      end
    end
  end
  return self
end

function Gen:initDefaults()
  for k, v in pairs(self.parameters) do
    if v.value then
      self:set{[k]=v.value}
    end
  end
  return self
end

function Gen:setDefault(new_params)
  local params = self.parameters
  for k, v in pairs(new_params) do
    if params[k] then
      params[k].value = v
    end
  end
  return Gen
end

function Gen:getDefault(param)
  return self.parameters[param].value
end

function Gen:start(frequency)
  self.frequency = frequency
  self.active = true
  return self
end

function Gen:stop()
  self.active = false
  return self
end

function Gen:continue()
  self.active = true
  return self
end

function Gen:generate(length_seconds)
  local length_samples = settings.sampleRate * length_seconds
  local sound_array = {}
  for i = 1, length_samples do
    sound_array[i] = self:tick()
  end
  return sound_array
end

local function Create()
  local new_class = {}
  local new_class_mt = {__index=Gen}
  setmetatable(new_class, new_class_mt)
  new_class.__index = new_class
  return new_class
end

return Create

end
end

do
local _ENV = _ENV
package.preload[ "Delay" ] = function( ... ) local arg = _G.arg;
local settings = require "settings"
local ring = require "ring"

local Delay = {}
Delay.__index = Delay

function Delay:new() -- time: seconds
  local gen = {
    time = 0,
    buffer = ring:new(1),
  }
  return setmetatable(gen, Delay)
end

function Delay:setLength(time)
  self.time = time
  self.buffer = ring:new(math.floor(settings.sampleRate * time)+1)
end

function Delay:clear() --TODO
  self.buffer:fill(0)
end

function Delay:tick(new_sample)
  self.buffer:apply(new_sample)
  return self.buffer:atOffset(0)
end


return Delay

end
end

do
local _ENV = _ENV
package.preload[ "KarplusStrong" ] = function( ... ) local arg = _G.arg;
local KarplusStrongFilter = require "KarplusStrongFilter"

local KS = require("generator")()
local ASR = require "ASR"

KS.pluckers = {}
KS.plucker_names = {}

function KS:requirePlucker(module_name)
  local new_plucker = require(module_name)
  if not new_plucker then
    return
  end
  KS.pluckers[module_name] = new_plucker
  table.insert(KS.plucker_names, module_name)
end

KS:requirePlucker("Sine")
KS:requirePlucker("Square")
KS:requirePlucker("Triangle")
KS:requirePlucker("WhiteNoise")

local type = type

-- Allowed parameters and their default values
KS.parameters = {
  plucker = {
    value = "Square",
    set = function(ks_obj, value)
      local value_type = type(value)
      if value_type == "string" then
        ks_obj.plucker = KS.pluckers[value]
      elseif value_type == "table" then
        ks_obj.plucker = value
      end
      ks_obj.input_gen = ks_obj.plucker:new()
    end,
  },
  frequency_multiplier = {
    value = 4,
  },
  distort_mul = {
    value = 0.2,
  },
}

function KS:new()
  local gen = {
    frequency = 0,
    sample_number = 0,
    ks_filter = KarplusStrongFilter:new(),
    input_gen_envelope = ASR:new(),
  }
  return setmetatable(gen, KS):initDefaults()
end

function KS:start(frequency)
  self.frequency = frequency
  self.ks_filter:setFrequency(frequency)
  self.ks_filter:clear()
  self.input_gen:start(frequency*self.frequency_multiplier)
  local size = self.ks_filter.delay_filter.buffer.size
  self.input_gen_envelope:set{attack_samples=size/2.0, sustain_samples=0, release_samples=size/2.0}:start()
  self.input_gen_envelope:start()
  self.old_frequency_multiplier = self.frequency_multiplier
  return self
end

function KS:fill_tick()
end

function KS:afterfill_tick()
end

function KS:tick()
  local input = self.input_gen_envelope:tick(self.input_gen)
  return self.ks_filter:tick(input) * 0.3 -- * self.distort_mul
end

return KS

end
end
return require 'LuaCanSound_init'
