moon = require "moonyscript"

--- Moonscript table serialization
-- Not for any serious usage, works only this tiny config writing
serialize = (T) ->
  local serializeDict, serializeArray, serializeValue

  serializeValue = (value, indent) ->
    if type(value) == "number"
      return value
    elseif type(value) == "string"
      return ('"%s"')\format(value)
    elseif type(value) == "boolean"
      return tostring(value)
    elseif type(value) == "table"
      fn = value[1] and serializeArray or serializeDict
      return fn(value, indent)
    elseif type(value) == "nil" -- Shouldn't happen, but sometimes #arr skips nils
      return "nil"

  serializeArray = (arr, indent) ->
    len = #arr
    if len == 0
      return "{}"
    strings = {"{"}
    for i = 1, #arr
      v = arr[i]
      table.insert(strings, serializeValue(v))
      if i ~= len
        table.insert(strings, ", ")
    table.insert(strings, "}")
    return table.concat(strings)

  serializeDict = (tab, indent) ->
    strings = {"{"}
    for key, value in pairs(tab)
      str = {("  ")\rep(indent + 1), key, ": ", serializeValue(value)}
      table.insert(strings, table.concat(str))
    table.insert(strings, ("  ")\rep(indent) .. "}\n")
    return table.concat(strings, "\n")
  return serializeValue(T, 0)

local settings

setDefaultSettings = ->
  default_settings = {
    graphics: true
    resolution: {900, 650}
  }
  settings = default_settings
  love.filesystem.write("settings.moon", serialize default_settings)

return setmetatable {}, {
  __index: (k) =>
    if not settings
      ok = pcall ->
        settings_loaded = load moon.compile (love.filesystem.read("settings.moon"))
        settings = settings_loaded!
      if not ok
        setDefaultSettings!
    return settings[k]
  __newindex: (k, v) =>
    settings[k] = v
    love.filesystem.write("settings.moon", serialize settings)
}
