local Orchestrator = require("core.orchestrator")

local Tui = {}
local path = "meu/projeto"
local output = Orchestrator.run(path)

function Tui.display(output)
  print(output)
end

return Tui
