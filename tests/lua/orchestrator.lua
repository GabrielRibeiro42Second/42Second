local Orchestrator = require("core.orchestrator")
local Assert = require("tests.lua.assert")

local output = Orchestrator.run("algum/caminho")

Assert.is_equals("string", type(output))
