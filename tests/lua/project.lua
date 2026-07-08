local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")

local Project = require("models.project")

Runner.run("Project.new() returns table", function()
  local project = Project.new()

  Assert.is_equals("table",
    type(project)
  )

  Assert.is_nil(project.path)
  Assert.is_nil(project.language)
  Assert.is_false(project.git)
  Assert.is_nil(project.readme)
  Assert.is_nil(project.docker)
  Assert.is_nil(project.layout)
  Assert.is_equals("table", type(project.plugins))
end)
