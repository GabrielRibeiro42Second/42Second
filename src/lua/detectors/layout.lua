--------------------------------------------------
---
--- Layout Detector
---
--- ---------------------------------------------

local Filesystem = require("utils.filesystem")

local LayouDetector = {}

function LayouDetector.detect(path)
  if Filesystem.exists(
        Filesystem.join(path, ".termos", "layout.lua")
      ) then
    return "layout.lua"
  end

  return nil
end

return LayouDetector
