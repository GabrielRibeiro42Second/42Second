----------------------------------------------------------
-- termOS Test Suite
----------------------------------------------------------

local Helpers = require("tests.framework.helpers")
local Runner = require("tests.framework.runner")

local SUITES = {
  "tests/lua/framework.lua",
  "tests/lua/project.lua",
  "tests/lua/filesystem.lua",
  "tests/lua/language_detector.lua",
  "tests/lua/git_detector.lua",
  "tests/lua/scanner.lua",
  "tests/lua/readme_detector.lua",
  "tests/lua/docker_detector.lua",
  "tests/lua/layout_detector.lua",
  "tests/lua/plugins_detector.lua",
  "tests/lua/inspector.lua",
  "tests/lua/presenter.lua",
  "tests/lua/orchestrator.lua",
  "tests/lua/tui.lua",
}

Helpers.header("termOS Test Suite")

for _, suite in ipairs(SUITES) do
  local ok, err = pcall(dofile, suite)

  if not ok then
    Runner.run(suite, function()
      error(err, 0)
    end)
  end
end

Runner.summary()

if Runner.success() then
  os.exit(0)
end

os.exit(1)
