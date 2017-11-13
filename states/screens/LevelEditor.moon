UI = require "lib.UI"

class LevelEditor
  new: =>
    UI.inject(@)
    UI.loadForm "PatternEditor"
