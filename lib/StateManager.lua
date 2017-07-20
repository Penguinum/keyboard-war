local gamestate = require("hump.gamestate")
local switcher
local States = { }
local previousStateId, currentStateId, currentState, previousState
local getState
getState = function(id)
  return States[id] or require("states." .. id)()
end
switcher = {
  switch = function(id)
    previousStateId = currentStateId
    currentStateId = id
    previousState = currentState
    currentState = getState(id)
    return gamestate.switch(currentState)
  end,
  pause = function(id)
    previousStateId = currentStateId
    currentStateId = id
    previousState = currentState
    currentState = getState(id)
    return gamestate.push(currentState)
  end,
  resume = function()
    currentStateId = previousStateId
    currentState = previousState
    return gamestate.pop()
  end,
  getPreviousStateId = function()
    return previousStateId
  end,
  getCurrentStateId = function()
    return currentStateId
  end,
  getStateById = function(id)
    return getState(id)
  end,
  getState = function()
    return currentState
  end
}
gamestate.registerEvents()
return switcher
