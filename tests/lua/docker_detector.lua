local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local DockerDetector = require("detectors.docker")

Runner.run("Docker exists", function()
  local docker = DockerDetector.detect(
    Helpers.fixture("docker")
  )

  Assert.is_true(docker)
end)

Runner.run("Docker does not exist", function()
  local docker = DockerDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_false(docker)
end)
