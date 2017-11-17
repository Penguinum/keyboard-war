player = Game.scene.spawnPlayer Vector 200, 200
pattern = Game.modules["patterns/test"]
player.keys = {
  ["shoot"]: Game.scene.spawnPattern pattern, {
    pos: @pos
    type: "good"
    color: {100, 100, 100}
    rad: 10
  }
}
-- print 123
