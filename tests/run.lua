----------------------------------------------------------
-- termOS Test Suite
----------------------------------------------------------

local Helpers = require("tests.framework.helpers")
local Runner = require("tests.framework.runner")

Helpers.header("termOS Test Suite")

dofile("tests/lua/filesystem.lua")
dofile("tests/lua/language_detector.lua")
dofile("tests/lua/git_detector.lua")
dofile("tests/lua/scanner.lua")
dofile("tests/lua/readme_detector.lua")
dofile("tests/lua/docker_detector.lua")
dofile("tests/lua/layout_detector.lua")
dofile("tests/lua/plugins_detector.lua")
dofile("tests/lua/inspector.lua")
dofile("tests/lua/presenter.lua")

Runner.summary()

if Runner.success() then
  os.exit(0)
end

os.exit(1)
