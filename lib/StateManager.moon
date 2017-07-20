gamestate = require "hump.gamestate"

local switcher

States = {}
local previousStateId, currentStateId, currentState, previousState

getState = (id) -> States[id] or require("states." .. id)!

switcher =
  switch: (id) ->
    previousStateId = currentStateId
    currentStateId = id
    previousState = currentState
    currentState = getState id
    gamestate.switch currentState

  pause: (id) ->
    previousStateId = currentStateId
    currentStateId = id
    previousState = currentState
    currentState = getState id
    gamestate.push currentState

  resume: ->
    currentStateId = previousStateId
    currentState = previousState
    gamestate.pop!

  getPreviousStateId: ->
    return previousStateId

  getCurrentStateId: ->
    return currentStateId

  getStateById: (id) ->
    return getState id

  getState: ->
    return currentState


gamestate.registerEvents!

switcher
