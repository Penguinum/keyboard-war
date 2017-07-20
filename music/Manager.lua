local love = love
local TrackManager
TrackManager = {
  tracks = { },
  aliases = { },
  tags = { },
  addTrack = function(args)
    assert(args.track)
    assert(args.alias)
    table.insert(TrackManager.tracks, args.track)
    TrackManager.aliases[args.alias] = #TrackManager.tracks
    if args.tag then
      TrackManager.tags[args.tag] = TrackManager.tags[args.tag] or { }
      table.insert(TrackManager.tags[args.tag], #TrackManager.tracks)
    end
    return TrackManager
  end,
  sendEventToTag = function(args)
    assert(args.event and args.tag)
    for i, idx in ipairs(TrackManager.tags[args.tag]) do
      TrackManager.tracks[idx][args.event](TrackManager.tracks[idx], args.parameters)
    end
  end,
  sendEventToAlias = function(args)
    assert(args.event and args.alias)
    return TrackManager.tracks[TrackManager.aliases[args.alias]][args.event](args.parameters)
  end,
  getTrack = function(alias)
    return TrackManager.tracks[TrackManager.aliases[alias]]
  end,
  update = function(dt)
    for _, v in pairs(TrackManager.tracks) do
      v:update(dt)
    end
    return TrackManager
  end
}
return TrackManager
