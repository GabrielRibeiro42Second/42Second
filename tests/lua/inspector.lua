local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Inspector = require("core.inspector")
local Project = require("models.project")

Runner.run("Inspector keeps the inspected project", function()
  local project = Project.new()
  local report = Inspector.inspect(project)

  Assert.is_equals(project, report.project)
end)

Runner.run("Inspector returns a suggestions list", function()
  local report = Inspector.inspect(Project.new())

  Assert.is_equals("table", type(report.suggestions))
end)

Runner.run("Inspector suggests a missing README.md", function()
  local project = Project.new()
  project.readme = false
  project.git = true

  local report = Inspector.inspect(project)

  Assert.is_equals(1, #report.suggestions)
  Assert.is_equals(
    "Projeto não possui README.md.",
    report.suggestions[1]
  )
end)

Runner.run("Inspector suggests a missing Git repository", function()
  local project = Project.new()
  project.readme = true
  project.git = false

  local report = Inspector.inspect(project)

  Assert.is_equals(1, #report.suggestions)
  Assert.is_equals(
    "Projeto não possui Git.",
    report.suggestions[1]
  )
end)

Runner.run("Inspector reports both missing README and Git", function()
  local report = Inspector.inspect(Project.new())

  Assert.is_equals(2, #report.suggestions)
  Assert.is_equals(
    "Projeto não possui README.md.",
    report.suggestions[1]
  )
  Assert.is_equals(
    "Projeto não possui Git.",
    report.suggestions[2]
  )
end)

Runner.run("Inspector has no suggestions when nothing is missing", function()
  local project = Project.new()
  project.readme = true
  project.git = true

  local report = Inspector.inspect(project)

  Assert.is_equals(0, #report.suggestions)
end)
