local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local ReadmeDetector = require("detectors.readme")

Runner.run("README exists", function()

  local readme = ReadmeDetector.detect(
    Helpers.fixture("readme")
  )

  Assert.is_true(readme)

end)

Runner.run("README does not exist", function()

  local readme = ReadmeDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_false(readme)
end)
