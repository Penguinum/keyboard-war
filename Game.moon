exportGlobals = ->
  export Vector = require "hump.vector"
  export Contorller = require "lib.Controller"
  export BasicCharacter = require "lib.BasicCharacter"
  export Menu = (menu) -> ->
    require("lib.Menu")(menu)

init = (path="game") ->
  const = require("const")
  SceneManager = require "lib.SceneManager"
  StateManager = require "lib.StateManager"
  local game
  unpack = unpack or table.unpack

  game =
    GAME_PATH: path
    quit: (exit_code) -> love.event.quit(exit_code)
    modules: setmetatable({}, {
      __index: (self, k) -> require(path .. "." .. k)
    })
    settings: require "Game/settings"
    scene:
      getWidth: -> const.scene_width
      getHeight: const.scene_height
      spawnPlayer: (pos) ->
        SceneManager\spawnPlayer pos
    graphics: require "Game/graphics"
    state:
      switch: (arg) -> StateManager.switch(arg)
      resume: (arg) -> StateManager.resume(arg)
  export Game = game
  exportGlobals!
  return game

{ :init }
