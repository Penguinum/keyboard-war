copy = require "util.copy"
Class = require "hump.class"

exportGlobals = ->
  export Vector = require "hump.vector"
  export Controller = require "lib.Controller"
  export BasicCharacter = require "lib.BasicCharacter"
  export Pattern = require "lib.Pattern"
  export Menu = (menu) -> ->
    require("lib.Menu")(menu)
  export derive = (classobject) ->
    (arg) ->
      args = copy arg
      args.__includes = classobject
      Class args


init = (path="game") ->
  const = require("const")
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
    scene: require "Game/scene"
    graphics: require "Game/graphics"
    music: require "Game/music"
    state:
      switch: (arg) -> StateManager.switch(arg)
      resume: (arg) -> StateManager.resume(arg)
  export Game = game
  exportGlobals!
  return game

{ :init }
