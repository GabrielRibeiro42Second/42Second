local Presenter = require("core.presenter")
local Project = require("models.project")
local Inspector = require("core.inspector")
local Assert = require("tests.framework.assert")

local project = Project.new()
local report = Inspector.inspect(project)

local output = Presenter.render(report)

Assert.is_equals(
  "string",
  type(output)
)
