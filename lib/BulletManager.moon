Layers = {}
Bullet2LayerMap = {}

Layer = {
  bullets: {}
  draw: =>
    for bullet in pairs @bullets
      bullet\draw!
  update: (dt) =>
    for bullet in pairs @bullets
      bullet\update dt
}
Layer.__index = Layer

newLayer = (drawlayer) ->
  setmetatable {:drawlayer}, Layer

BulletManager =
  id: 0
  size: 0
  last: 0
  addBullet: (b) =>
    layer = Layers[b.drawlayer]
    if not layer
      layer = newLayer b.drawlayer
      Layers[b.drawlayer] = layer
      Game.scene\spawn layer
    layer.bullets[b] = true
    b.id = @id
    b.hitbox.id = @id
    @id += 1
    Bullet2LayerMap[b] = layer

  removeBullet: (b) =>
    Bullet2LayerMap[b].bullets[b] = nil
    Bullet2LayerMap[b] = nil

  removeAllBullets: =>
    for b in pairs(Bullet2LayerMap)
      b\remove!

return BulletManager
