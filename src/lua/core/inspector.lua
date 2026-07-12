local Inspector = {}

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

  if project.git == false then
    table.insert(
      report.suggestions,
      "Projeto não possui Git."
    )
  end
  return report
end

return Inspector
