SceneManager = require "lib.SceneManager"
Vector = require "hump.vector"
import Bullet from require "lib.Bullet"

enemies = {
  simple1: {
    pos: Vector(5, 10) -- Too bad we have to use px coords atm. FIXME
    move: (dt) =>
      @pos = @pos + 200 * Vector(1, 1) * dt
    shoot: =>
      if math.random! > 0.9
        Bullet{
          pos: @pos + Vector(0, 10)
          speed: math.random(50, 100)
          dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
        }
  }
  simple2: {
    pos: Vector(595, 10) -- FIXME
    move: (dt) =>
      @pos = @pos + 200 * Vector(-1, 1) * dt
    shoot: =>
      if math.random! > 0.9
        Bullet{
          pos: @pos + Vector(0, 10)
          speed: math.random(50, 100)
          dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
        }
  }
  challenging1: {
    pos: Vector(5, 10) -- Too bad we have to use px coords atm. FIXME
    text: "(・`ω´・)"
    width: 60
    move: (dt) =>
      @pos = @pos + 200 * Vector(1, 1) * dt
    shoot: =>
      Bullet{
        pos: @pos + Vector(0, 10)
        speed: math.random(50, 100)
        dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
      }
  }
  challenging2: {
    pos: Vector(595, 10) -- FIXME
    text: "(・`ω´・)"
    width: 60
    move: (dt) =>
      @pos = @pos + 200 * Vector(-1, 1) * dt
    shoot: =>
      Bullet{
        pos: @pos + Vector(0, 10)
        speed: math.random(50, 100)
        dir: Vector(0.2*(math.random!-0.5), math.random!)\normalized!
      }
  }
}

{
  music: "Confusion"
  {
    time: 0, action: ->
      SceneManager\spawnEnemy enemies.simple1
      SceneManager\spawnEnemy enemies.simple2
  }
  {
    time: 2, action: ->
      SceneManager\spawnEnemy enemies.challenging1
      SceneManager\spawnEnemy enemies.challenging2
  }
  {
    time: 3, action: ->
      SceneManager\spawnEnemy {
        pos: Vector(0, 30), text: "(╬`益´)", width: 60
        move: (dt) =>
          @pos = @pos + 500 * Vector(1, 0) * dt
        shoot: =>
          for i = 1, 3 do
            Bullet{
              pos: @pos + Vector(0, 20 * i)
              speed: 400 --math.random(50, 100)
              dir: Vector(0, 1)
            }
      }
      SceneManager\spawnEnemy {
        pos: Vector(570, 30), text: "(`益´╬)", width: 60
        move: (dt) =>
          @pos = @pos + 500 * Vector(-1, 0) * dt
        shoot: =>
          for i = 1, 3 do
            Bullet{
              pos: @pos + Vector(0, 20 * i)
              speed: 400 --math.random(50, 100)
              dir: Vector(0, 1)
            }
      }

  }
  {
    time: 3.1, action: ->
      SceneManager\spawnEnemy enemies.challenging1
      SceneManager\spawnEnemy enemies.challenging2
  }
  {
    time: 4, action: ->
      SceneManager\spawnEnemy {
        pos: Vector(30, -10), text: "(╬`益´)", width: 60
        move: (dt) =>
          @pos = @pos + 50 * Vector(0, 1) * dt
        shoot: =>
          for i = 1, 3 do
            Bullet{
              pos: @pos + Vector(20 * i, 0)
              speed: 400 --math.random(50, 100)
              dir: Vector(1, 0)
            }
      }
      SceneManager\spawnEnemy {
        pos: Vector(570, -10), text: "(`益´╬)", width: 60
        move: (dt) =>
          @pos = @pos + 50 * Vector(0, 1) * dt
        shoot: =>
          for i = 1, 3 do
            Bullet{
              pos: @pos - Vector(20 * i, 0)
              speed: 400 --math.random(50, 100)
              dir: Vector(-1, 0)
            }
      }
  }
  {
    time: 5, action: ->
      SceneManager\spawnEnemy {
        pos: Vector(30, -10), text: "(╬`益´)", width: 60
        move: (dt) =>
          @pos = @pos + 500 * Vector(0, 1) * dt
        shoot: =>
          Bullet{
            pos: @pos + Vector(10, 0)
            speed: 400 --math.random(50, 100)
            dir: Vector(1, 0)
          }
      }
      SceneManager\spawnEnemy {
        pos: Vector(570, -10), text: "(`益´╬)", width: 60
        move: (dt) =>
          @pos = @pos + 500 * Vector(0, 1) * dt
        shoot: =>
          Bullet{
            pos: @pos - Vector(10, 0)
            speed: 400 --math.random(50, 100)
            dir: Vector(-1, 0)
          }
      }
  }
  {
    time: 10
    action: ->
      SceneManager\spawnBoss {
        pos: Vector(0.5, 0.05)
        income_pos: Vector(0.5, -0.05)
      }
  }
}
