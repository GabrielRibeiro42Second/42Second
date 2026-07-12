local Inspector = require("core.inspector")
local Assert = require("tests.framework.assert")
local Project = require("models.project")

local project = Project.new()
local report = Inspector.inspect(project)

Assert.is_equals(project, report.project)
Assert.is_equals("table", type(report.suggestions))
Assert.is_false(project.readme)
Assert.is_false(project.git)
Assert.is_equals(2, #report.suggestions)
Assert.is_equals(
  "Projeto não possui README.md.",
  report.suggestions[1]
)
Assert.is_equals(
  "Projeto não possui Git.",
  report.suggestions[2]
)
