------------------------------------------------------------
-- README Detector
------------------------------------------------------------

local Filesystem = require("utils.filesystem")

local ReadmeDetector = {}

function ReadmeDetector.detect(path)
  return Filesystem.exists(
    Filesystem.join(path, "README.md")
  )
end

return ReadmeDetector
