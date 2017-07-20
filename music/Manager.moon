love = love

local TrackManager
TrackManager =
  tracks: {}
  aliases: {}
  tags: {}
  addTrack: (args) ->
    assert args.track
    assert args.alias
    table.insert(TrackManager.tracks, args.track)
    TrackManager.aliases[args.alias] = #TrackManager.tracks
    if args.tag
      TrackManager.tags[args.tag] = TrackManager.tags[args.tag] or {}
      table.insert(TrackManager.tags[args.tag], #TrackManager.tracks)
    return TrackManager

  sendEventToTag: (args) ->
    assert(args.event and args.tag)
    for i, idx in ipairs TrackManager.tags[args.tag]
      TrackManager.tracks[idx][args.event] TrackManager.tracks[idx], args.parameters

  sendEventToAlias: (args) ->
    assert(args.event and args.alias)
    TrackManager.tracks[TrackManager.aliases[args.alias]][args.event] args.parameters

  getTrack: (alias) ->
    return TrackManager.tracks[TrackManager.aliases[alias]]

  update: (dt) ->
    for _, v in pairs TrackManager.tracks
      v\update dt
    return TrackManager

return TrackManager
