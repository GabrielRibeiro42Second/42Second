------------------------------------------------------------
-- Layout Detector
--
-- Detecta um layout declarado dentro do próprio projeto
-- (.termos/layout.lua).
------------------------------------------------------------

local Filesystem = require("utils.filesystem")

local LayoutDetector = {}

function LayoutDetector.detect(path)
  if Filesystem.exists(
        Filesystem.join(path, ".termos", "layout.lua")
      ) then
    return "layout.lua"
  end

  return nil
end

return LayoutDetector
