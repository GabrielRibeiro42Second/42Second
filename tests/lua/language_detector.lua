local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local LanguageDetector = require("detectors.language")

Runner.run("Detect Java", function()

  local language = LanguageDetector.detect(
    Helpers.fixture("java")
  )

  Assert.is_equals("java", language)

end)

Runner.run("Detect Node", function()

  local language = LanguageDetector.detect(
    Helpers.fixture("node")
  )

  Assert.is_equals("node", language)
end)

Runner.run("Detect Python", function()

  local language = LanguageDetector.detect(
    Helpers.fixture("python")
  )

  Assert.is_equals("python", language)

end)

Runner.run("Unknown project", function()

  local language = LanguageDetector.detect(
    Helpers.fixture("empty")
  )

  Assert.is_nil(language)

end)
