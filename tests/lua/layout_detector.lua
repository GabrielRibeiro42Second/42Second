local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helper = require("tests.framework.helpers")

local LayoutDetector = require("detectors.layout")

Runner.run("Layout exists", function()
  local layout = LayoutDetector.detect(
    Helper.fixture("layout")
  )

  Assert.is_equals(
    "layout.lua",
    layout
  )
end)

Runner.run("Layout does not exists", function()
  local layout = LayoutDetector.detect(
    Helper.fixture("empty")
  )

  Assert.is_nil(layout)
end)
