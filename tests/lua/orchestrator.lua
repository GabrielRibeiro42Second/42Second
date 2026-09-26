local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Orchestrator = require("core.orchestrator")

local MISSING_PROJECT = "algum/caminho"

Runner.run("Orchestrator.run renders the report as a string", function()
  Assert.is_equals(
    "string",
    type(Orchestrator.run(MISSING_PROJECT))
  )
end)

Runner.run("Orchestrator.run reports a missing README", function()
  local output = Orchestrator.run(MISSING_PROJECT)

  Assert.isnot_nil(
    output:find("Projeto não possui README.md.", 1, true)
  )
end)
