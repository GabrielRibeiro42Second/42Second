local Orchestrator = require("core.orchestrator")
local Assert = require("tests.framework.assert")

local output = Orchestrator.run("algum/caminho")
local analize = Orchestrator.analize(output)

Assert.is_equals("table", type(output))
Assert.is_equals("table", type(analize))
