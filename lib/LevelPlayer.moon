MusicPlayer = require "lib.MusicPlayer"

class LevelPlayer
  new: (level) =>
    @events = level or {}
    @time = 0
    @current_event = 1
    MusicPlayer.playTrack {name: level.music, alias: level.music}

  update: (dt) =>
    @time += dt
    event = @events[@current_event]
    if event and @time >= event.time
      @current_event += 1
      event.action!
