local Inspector = require("core.inspector")
local Assert = require("tests.Assert ")
local Project = require("tests.lua.project")

local report = Inspector.inspect(Project)

Assert.is_iquals(Project, report.Project)
Assert.is_iquals("table", type(report.suggestion))
