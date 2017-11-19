Vector = Vector
Controller = Controller
BasicCharacter = BasicCharacter
pattern = Game.modules["patterns/test"]
text2img = require "util.text2image"
HC = require "HCWorld"
config = require "config"

Player = derive(BasicCharacter)
  textart: {
    text: "(=^･ｪ･^=)"
    font: "art"
    color: {100, 255, 100}
  }
  init: =>
    @pos = Vector 0, 0
    @state = "default"
    @slowspeed = 100
    @lives = 3
    @drawlayer = 5
    @speed = 300
    @image = text2img @textart
    @width = @image\getWidth!
    @height = @image\getHeight!
    -- Game.ui.updatePlayerInfo {lives: @lives, bombs: @bombs}
    @hitbox = HC\circle @pos.x, @pos.y, 5

  setPos: (pos) =>
    @pos = pos
    @hitbox\moveTo pos.x, pos.y


  draw: =>
    if config.debug
      @hitbox\draw!
    love.graphics.draw @image, @pos.x, @pos.y, 0, 1, 1, @width / 2, @height / 2

  spawnPattern: =>
    -- TODO: spawn patterns after key released
    -- Change parameters depending on how long key was pressed
    -- Draw some "energy bar"
    Game.scene\spawn pattern {
      pos: @pos
      color: { 255, 255, 255 }
      rad: 15
    }

  update: (dt) =>
    vec = Vector 0
    if Controller.pressed "left" then
      vec.x = -1
    elseif Controller.pressed "right" then
      vec.x = 1

    if Controller.pressed "down" then
      vec.y = 1
    elseif Controller.pressed "up" then
      vec.y = -1

    if Controller.pressed "shoot" then
      @shoot!

    local speed
    if Controller.pressed "slowdown"
      speed = @slowspeed
      @draw_hitbox = true
    else
      speed = @speed
      @draw_hitbox = false

    newpos = @pos + dt * speed * vec\normalized!
    if newpos.x < 0
      newpos.x = 0
    elseif newpos.x > Game.scene.width
      newpos.x = Game.scene.width
    if newpos.y > Game.scene.height
      newpos.y = Game.scene.height
    elseif newpos.y < 0
      newpos.y = 0
    @setPos newpos

  shoot: =>
    dist = 20
    if Controller.pressed "slowdown"
      dist = 10

  keypressed: (key) =>
    if Controller.getActionByKey(key) == "pattern4debug"
      @spawnPattern!

return Player
