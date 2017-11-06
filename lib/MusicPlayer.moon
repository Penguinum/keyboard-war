love = love

STATE_FADEIN = 1
STATE_NORMAL = 2
STATE_FADEOUT = 3
STATE_FINAL = 4

class Track
  new: (source) =>
    assert(type(source) == "string")
    @source = love.audio.newSource(source)
    @started = false

  set: (args) =>
    for k, v in pairs args
      @[k] = v
    return@

  play: (fadein) =>
    fadein = fadein or @fadein
    @started = true
    if not fadein or fadein == 0
      @level = 1
      @state = STATE_NORMAL
    else
      @level = 0
      @state = STATE_FADEIN
      @fadein_speed = 1 / fadein
    @source\setVolume(@level)
    @source\play()


  resume: (fadein) =>
    fadein = fadein or @fadein
    if not fadein or fadein == 0
      @level = 1
      @state = STATE_NORMAL
    else
      @level = @level or 0
      @state = STATE_FADEIN
      @fadein_speed = 1 / fadein
    @source\setVolume(@level)
    if not @started
      @source\play!
    else
      @source\resume!

  stop: (fadeout) =>
    fadeout = fadeout or @fadeout
    @started = false
    if not fadeout or fadeout == 0
      @state = STATE_FINAL
      @level = 0
    else
      @state = STATE_FADEOUT
      @fadeout_speed = 1 / fadeout
      @action = @source.stop

  pause: (fadeout) =>
    fadeout = fadeout or @fadeout
    if not fadeout or fadeout == 0
      @state = STATE_FINAL
      @level = 0
    else
      @state = STATE_FADEOUT
      @fadeout_speed = 1 / fadeout
      @action = @source.pause

  update: (dt) =>
    if @state == STATE_FADEIN
      @level += dt * @fadein_speed
    elseif @state == STATE_FADEOUT
      @level -= dt * @fadeout_speed
    if @level < 0
      @level = 0
      @.action(@source)
    elseif @level > 1
      @level = 1
    @source\setVolume(@level)

local MusicPlayer
MusicPlayer =
  tracks: {}
  aliases: {}
  tags: {}
  addTrack: (args) ->
    assert args.name
    assert args.alias
    track = Track("resources/music/"..args.name..".ogg")\set{fadein:1, fadeout:1}
    table.insert(MusicPlayer.tracks, track)
    MusicPlayer.aliases[args.alias] = #MusicPlayer.tracks
    if args.tag
      MusicPlayer.tags[args.tag] = MusicPlayer.tags[args.tag] or {}
      table.insert(MusicPlayer.tags[args.tag], #MusicPlayer.tracks)
    return MusicPlayer

  sendEventToTag: (args) ->
    assert(args.event and args.tag)
    if not MusicPlayer.tags[args.tag]
      return
    for i, idx in ipairs MusicPlayer.tags[args.tag]
      MusicPlayer.tracks[idx][args.event] MusicPlayer.tracks[idx], args.parameters

  sendEventToAlias: (args) ->
    assert(args.event and args.alias)
    MusicPlayer.tracks[MusicPlayer.aliases[args.alias]][args.event] args.parameters

  getTrack: (alias) ->
    return MusicPlayer.tracks[MusicPlayer.aliases[alias]]

  update: (dt) ->
    for _, v in pairs MusicPlayer.tracks
      v\update dt
    return MusicPlayer

return MusicPlayer
