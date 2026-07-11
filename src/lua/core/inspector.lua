local Inspector = {}

function Inspector.inspect(project)
  return {
    project = project,
    suggestion = {}
  }
end

return Inspector
