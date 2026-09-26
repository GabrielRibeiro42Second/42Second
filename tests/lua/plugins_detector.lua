local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local PluginsDetector = require("detectors.plugins")

Runner.run("Plugins detector return table", function()
  local plugins = PluginsDetector.detect(
    Helpers.fixture("plugins")
  )

  Assert.is_equals(3, #plugins)
end)

Runner.run("Plugins detector returns empty table", function()
  local plugins = PluginsDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_equals(0, #plugins)
end)

Runner.run("Plugins detector is order independent", function()
  local plugins = PluginsDetector.detect(
    Helpers.fixture("plugins")
  )

  table.sort(plugins)

  Assert.is_equals("docker.lua", plugins[1])
  Assert.is_equals("git.lua", plugins[2])
  Assert.is_equals("roadmap.lua", plugins[3])
end)
