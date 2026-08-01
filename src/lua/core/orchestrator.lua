local Scanner = require("core.scanner")
local Inspector = require("core.inspector")
local Presenter = require("core.presenter")

local Orchestrator = {}

function Orchestrator.run(path)
  local project = Scanner.scan(path)
  local report = Inspector.inspect(project)
  local output = Presenter.render(report)
  return output
end

return Orchestrator
