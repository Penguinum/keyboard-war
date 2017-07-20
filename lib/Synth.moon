LCS = require "LuaCanSound"

class Synth
  env = LCS.envelopes.ASR\new()
  generator_cache = {}
  cache = {}
  with env
    \set{attack_seconds: 0.01}
    \set{sustain_seconds: 0.05}
    \set{decay_seconds: 0.01}

  load_gen: (gen) =>
    if not generator_cache[gen]
      generator_cache[gen] = LCS.generators[gen]\new!
    return generator_cache[gen]

  generate: (arg) =>
    generator = @load_gen(arg.gen)
    generator\start arg.freq
    env\start!
    length = LCS.settings.sampleRate * arg.length
    sample = love.sound.newSoundData(length, LCS.settings.sampleRate, 16, 1)
    for i = 0, length-1
      sample\setSample i, generator\tick!*env\tick!*0.1
    return sample

  play: (arg) =>
    arg.gen = arg.gen or "Triangle"
    arg_serialized = arg.gen..":"..arg.freq .. ":" .. arg.length
    if not cache[arg_serialized]
      cache[arg_serialized] = @generate arg
    love.audio.play love.audio.newSource cache[arg_serialized]

return Synth!
