local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")


local GitDetector = require("detectors.git")

Runner.run("Git repository", function()
  local git = GitDetector.detect(
    Helpers.fixture("git")
  )

  Assert.is_true(git)
end)

Runner.run("Non git repository", function()
  local git = GitDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_false(git)
end)
