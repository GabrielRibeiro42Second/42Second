local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Presenter = require("core.presenter")
local Inspector = require("core.inspector")
local Project = require("models.project")

local function report()
  return Inspector.inspect(Project.new())
end

Runner.run("Presenter.render returns a string", function()
  Assert.is_equals("string", type(Presenter.render(report())))
end)

Runner.run("Presenter.render lists every suggestion", function()
  local output = Presenter.render(report())

  Assert.isnot_nil(
    output:find("Projeto não possui README.md.", 1, true)
  )
  Assert.isnot_nil(
    output:find("Projeto não possui Git.", 1, true)
  )
end)
