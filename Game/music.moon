Track = require "lib.AudioTrack"

MusicPlayer =
  tracks: {}
  stack: {}
  play: (name) =>
    local track
    if not @tracks[name]
      @tracks[name] = Track(Game.GAME_PATH.."/"..name)\set{fadein:1, fadeout:1}
    track = @tracks[name]
    table.insert(@stack, track)
    track\play!
    return @

  sendEvent: (args) =>
    for k, track in pairs @.tracks
      track[args.event] track, args.parameters

  update: (dt) =>
    for _, track in pairs @.stack
      track\update dt
    return @

  pauseCurrent: =>
    if @.stack[#@.stack]
      @.stack[#@.stack]\pause!

  resumeCurrent: =>
    if @.stack[#@.stack]
      @.stack[#@.stack]\resume!

return MusicPlayer
