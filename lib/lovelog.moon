disabled = true
strings = {}

disable = ->
  disabled = true

enable = ->
  disabled = false

toggle = ->
  disabled = not disabled

reset = ->
  strings = {}

print = (...) ->
  if disabled
    return
  table.insert(strings, table.concat({...}))

render = ->
  if disabled
    return
  for i, text in ipairs strings
    love.graphics.print text, 0, (i - 1) * 15

{
  :reset,
  :print,
  :render,
  :disable,
  :enable,
  :toggle,
}
