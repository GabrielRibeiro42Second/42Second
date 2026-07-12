local Inspector = require("core.inspector")
local Assert = require("tests.lua.assert")
local Project = require("models.project")

local project = Project.new()
local report = Inspector.inspect(project)

Assert.is_iquals(project, report.project)
Assert.is_iquals("table", type(report.suggestions))
Assert.is_false(project.readme)
Assert.is_false(project.git)
Assert.is_iquals(2, #report.suggestions)
Assert.is_iquals(
  "Projeto não possui README.md",
  report.suggestions[1]
)
Assert.is_iquals(
  "Projeto não possui Git",
  report.suggestions[2]
)
