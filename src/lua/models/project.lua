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

return Project
