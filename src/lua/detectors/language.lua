----------------------------------------------------------
-- Language Detector
----------------------------------------------------------

local Filesystem = require("utils.filesystem")

local LanguageDetector = {}

----------------------------------------------------------
-- Public API
----------------------------------------------------------

function LanguageDetector.detect(path)
  if Filesystem.exists(path .. "/pom.xml") then
    return "java"
  end

  if Filesystem.exists(path .. "/build.gradle") then
    return "java"
  end

  if Filesystem.exists(path .. "/package.json") then
    return "node"
  end

  if Filesystem.exists(path .. "/pyproject.toml") then
    return "python"
  end

  return nil
end

return LanguageDetector
