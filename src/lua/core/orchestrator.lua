local Scanner = require("core.scanner")
local Inspector = require("core.inspector")
local presenter = require("core.presenter")

local Orchestrator = {}

function Orchestrator.run(path)
  local project = Scanner.scan(path)
  local report = Inspector.inspect(project)
  local output = presenter.render(report)
  return output
end

return Orchestrator
