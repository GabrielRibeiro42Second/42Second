----------------------------------------------------------
-- Language Detector
--
-- Espelha a ordem e os marcadores de
-- src/bash/workspace/detector.sh para que o CLI bash e o
-- pipeline Lua nunca discordem sobre o tipo de projeto.
----------------------------------------------------------

local Filesystem = require("utils.filesystem")

local LanguageDetector = {}

-- ordem = prioridade (a primeira ocorrência vence)
local MARKERS = {
  { "pom.xml",          "java" },
  { "build.gradle",     "java" },
  { "build.gradle.kts", "java" },
  { "pyproject.toml",   "python" },
  { "setup.py",         "python" },
  { "requirements.txt", "python" },
  { "package.json",     "node" },
  { "Cargo.toml",       "rust" },
  { "go.mod",           "go" },
  { "Makefile",         "make" },
  { "CMakeLists.txt",   "cmake" },
  { "justfile",         "just" },
  { "Dockerfile",       "docker" },
}

function LanguageDetector.detect(path)
  for _, marker in ipairs(MARKERS) do
    if Filesystem.exists(Filesystem.join(path, marker[1])) then
      return marker[2]
    end
  end

  return nil
end

return LanguageDetector
