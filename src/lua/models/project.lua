----------------------------------------------------------
-- Project Model
----------------------------------------------------------

local Project = {}

function Project.new()
  return {
    path = nil,
    language = nil,
    git = false,
    readme = false,
    docker = false,
    layout = nil,
    plugins = {}
  }
end

function Project.configure(project, data)
  project.path = data.path
  project.language = data.language
  project.git = data.git
  project.readme = data.readme
  project.docker = data.docker
  project.layout = data.layout
  project.plugins = data.plugins
end

return Project
