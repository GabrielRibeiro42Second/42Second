local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local LanguageDetector = require("detectors.language")

Runner.run("Detect Java", function()
  Assert.is_equals("java", LanguageDetector.detect(
    Helpers.fixture("java")
  ))
end)

Runner.run("Detect Node", function()
  Assert.is_equals("node", LanguageDetector.detect(
    Helpers.fixture("node")
  ))
end)

Runner.run("Detect Python", function()
  Assert.is_equals("python", LanguageDetector.detect(
    Helpers.fixture("python")
  ))
end)

Runner.run("Unknown project", function()
  Assert.is_nil(LanguageDetector.detect(
    Helpers.fixture("empty")
  ))
end)

-- O detector bash (workspace/detector.sh) checa pyproject.toml
-- antes de package.json. O Lua precisa concordar, senão o
-- relatório e o workspace dizem coisas diferentes.
Runner.run("Python wins over Node (parity with bash)", function()
  Assert.is_equals("python", LanguageDetector.detect(
    Helpers.fixture("polyglot")
  ))
end)

Runner.run("Unknown directory returns nil", function()
  Assert.is_nil(LanguageDetector.detect(
    Helpers.fixture("empty") .. "/nao_existe"
  ))
end)
