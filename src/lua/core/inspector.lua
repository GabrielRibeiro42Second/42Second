local Inspector = {}

function Inspector.inspect(project)
  return {
    project = project,
    suggestions = {
      project.readme == false
    }
  }
end

return Inspector
