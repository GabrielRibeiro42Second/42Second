local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local LayoutDetector = require("detectors.layout")

Runner.run("Layout exists", function()
  local layout = LayoutDetector.detect(
    Helpers.fixture("layout")
  )

  Assert.is_equals(
    "layout.lua",
    layout
  )
end)

Runner.run("Layout does not exists", function()
  local layout = LayoutDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_nil(layout)
end)
