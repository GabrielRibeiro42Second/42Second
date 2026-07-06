local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")

local Project = require("models.project")

Runner.run("Project.new() returns table", function()
  local project = Project.new()

  Assert.is_equals("table",
    type(project)
  )
end)
