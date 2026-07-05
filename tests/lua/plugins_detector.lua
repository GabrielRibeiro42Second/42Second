local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local PluguinsDetector = require("detectors.plugins")

Runner.run("Plugins detector return table", function()
  local plugins = PluguinsDetector.detect(
    Helpers.fixture("plugins")
  )

  Assert.is_equals(3, #plugins)
end)

Runner.run("Plugins detector returns empty table", function()
  local plugins = PluguinsDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_equals(0, #plugins)
end)
