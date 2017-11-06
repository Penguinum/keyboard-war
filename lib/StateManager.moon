--- Switches gamestates

gamestate = require "hump.gamestate"

local switcher
local previousStateId, currentStateId, currentState, previousState

getStage = (id) ->
  stage = require("states.stages." .. id)!
  stage.isStage = true
  return stage
getScreen = (id) -> require("states.screens." .. id)!

switcher =
  --- Switch to some game state (screen or stage)
  -- @param args -- table {screen or stage: stage/screen id, [pause: is pause menu]}
  -- if pause menu then previous state will be drawn (maybe) but not updated
  switch: (args) ->
    previousStateId = currentStateId
    currentStateId = args.screen or args.stage
    previousState = currentState
    currentState = (args.screen and getScreen or getStage)(currentStateId)
    (args.pause and gamestate.push or gamestate.switch)(currentState)
    switcher.PLAYABLE_STATE = args.stage and true -- TODO Replace with better solution

  --- Resume paused game state (in case we have it)
  resume: ->
    currentStateId = previousStateId
    currentState = previousState
    switcher.PLAYABLE_STATE = currentState.isStage
    gamestate.pop!

  getPreviousStateId: ->
    return previousStateId

  getCurrentStateId: ->
    return currentStateId

  getStateById: (id) ->
    return getStage id

  getState: ->
    return currentState

gamestate.registerEvents!

switcher
