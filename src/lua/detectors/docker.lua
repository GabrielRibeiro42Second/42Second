----------------------------------------------------------
-- Docker Detector
----------------------------------------------------------

local Filesystem = require("utils.filesystem")

local DockerDetector = {}

function DockerDetector.detect(path)
  return Filesystem.exists(
    Filesystem.join(path, "Dockerfile")
  )
end

return DockerDetector
