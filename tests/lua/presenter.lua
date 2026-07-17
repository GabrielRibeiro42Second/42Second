local Presenter = require("tests.lua.presenter")
local Project = require("models.project")
local Inspector = require("core.inspector")

local project = Project.new()
local report = Inspector.inspect(project)


Presenter.render(report)
