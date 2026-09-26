local Project          = require("models.project")
local LayoutDetector   = require("detectors.layout")
local DockerDetector   = require("detectors.docker")
local GitDetector      = require("detectors.git")
local LanguageDetector = require("detectors.language")
local ReadmeDetector   = require("detectors.readme")
local PluginsDetector  = require("detectors.plugins")

local Scanner = {}

function Scanner.scan(path)
  local project = Project.new()

  Project.configure(project, {
    path = path,
    language = LanguageDetector.detect(path),
    git = GitDetector.detect(path),
    readme = ReadmeDetector.detect(path),
    docker = DockerDetector.detect(path),
    layout = LayoutDetector.detect(path),
    plugins = PluginsDetector.detect(path)
  })

  return project
end

return Scanner
