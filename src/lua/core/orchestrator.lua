local Scanner = require("core.scanner")
local Inspector = require("core.inspector")

local Orchestrator = {}

function Orchestrator.run(path)
  local project = Scanner.scan(path)
  return project
end

function Orchestrator.analize(path)
  local project = Orchestrator.run(path)
  local report = Inspector.inspect(project)
  return report
end

return Orchestrator
