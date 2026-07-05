local Filesystem = require("utils.filesystem")

local GitDetector = {}

function GitDetector.detect(path)
  return Filesystem.exists(
    Filesystem.join(path, ".git")
  )
end

return GitDetector
