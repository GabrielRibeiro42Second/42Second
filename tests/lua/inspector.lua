local Inspector = require("core.inspector")
local Assert = require("tests.lua.assert")
local Project = require("models.project")

local report = Inspector.inspect(Project)

Assert.is_iquals(Project, report.Project)
Assert.is_iquals("table", type(report.suggestion))
Assert.is_false(Project)
