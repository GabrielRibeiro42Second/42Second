local Filesystem       = require("utils.filesystem")
local Project          = require("models.project")
local LayoutDetecotr   = require("detectors.layout")
local DockerDetector   = require("detectors.docker")
local GitDetector      = require("detectors.git")
local LanguageDetector = require("detectors.language")
local ReadmeDetector   = require("detectors.readme")
local PluginsDetector  = require("detectors.plugins")

local Scanner          = {}

function Scanner.scan(path)
  local project = Project.new()

  project.path = path
  project.language = LanguageDetector.detect(path)
  project.git = GitDetector.detect(path)
  project.readme = ReadmeDetector.detect(path)
  project.docker = DockerDetector.detect(path)
  project.layout = LayoutDetecotr.detect(path)
  project.plugins = PluginsDetector.detect(path)

  return project
end

return Scanner
