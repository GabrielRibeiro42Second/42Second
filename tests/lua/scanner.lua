local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local Scanner = require("core.scanner")

Runner.run("Scanner detects Java project", function()
  local project = Scanner.scan(
    Helpers.fixture("java")
  )

  Assert.is_equals(
    Helpers.fixture("java"),
    project.path
  )

  Assert.is_equals(
    "java",
    project.language
  )
  Assert.is_false(project.git)
  Assert.is_false(project.readme)
  Assert.is_false(project.docker)
  Assert.is_nil(project.layout)
  Assert.is_equals(
    "table",
    type(project.plugins)
  )
end)

Runner.run("Scanner detects Node project", function()
  local project = Scanner.scan(
    Helpers.fixture("node")
  )

  Assert.is_equals(
    "node",
    project.language
  )
  Assert.is_false(project.git)
end)

Runner.run("Scanner detects Python project", function()
  local project = Scanner.scan(
    Helpers.fixture("python")
  )

  Assert.is_equals(
    "python",
    project.language
  )
  Assert.is_false(project.git)
end)

Runner.run("Scanner detects unknown project", function()
  local project = Scanner.scan(
    Helpers.fixture("empty")
  )

  Assert.is_nil(
    project.language
  )
end)

Runner.run("Scanner detects Git repository", function()
  local project = Scanner.scan(
    Helpers.fixture("git")
  )

  Assert.is_true(project.git)
end)
