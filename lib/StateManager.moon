--- Switches gamestates
gamestate = require "hump.gamestate"
signal = require "hump.signal"

local switcher
local previousStateId, currentStateId, currentState, previousState

getLevel = (id) ->
  SceneManager = require "lib.SceneManager"
  require(Game.GAME_PATH .. ".levels." .. id)
  SceneManager\reset!
  SceneManager.isStage = true
  return SceneManager
getScreen = (id) -> require(Game.GAME_PATH .. ".screens." .. id)!

switcher =
  --- Switch to some game state (screen or stage)
  -- @param args -- table {screen or stage: stage/screen id, [pause: is pause menu]}
  -- if pause menu then previous state will be drawn (maybe) but not updated
  switch: (args) ->
    previousStateId = currentStateId
    currentStateId = args.screen or args.stage
    previousState = currentState
    currentState = (args.screen and getScreen or getLevel)(currentStateId)
    (args.pause and gamestate.push or gamestate.switch)(currentState)
    if not args.pause and args.screen
      signal.emit "leave scene"
    elseif args.pause
      signal.emit "pause"
    switcher.PLAYABLE_STATE = args.stage and true -- TODO Replace with better solution

  --- Resume paused game state (in case we have it)
  resume: ->
    currentStateId = previousStateId
    currentState = previousState
    switcher.PLAYABLE_STATE = currentState.isStage
    gamestate.pop!
    signal.emit "resume scene"

  getPreviousStateId: ->
    return previousStateId

  getCurrentStateId: ->
    return currentStateId

  getState: ->
    return currentState

gamestate.registerEvents!

switcher
