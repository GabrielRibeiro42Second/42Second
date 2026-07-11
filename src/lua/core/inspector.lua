local Project = require("models.project")

local Inspector = {}
local project = Project.new()

function Inspector.inspect(project)
  local report = {
    project = project,
    suggestions = {}
  }
  if project.readme == false then
    table.insert(report.suggestions,
      "Projeto não possui README.md"
    )
  end
end

return Inspector
