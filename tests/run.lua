----------------------------------------------------------
-- termOS Test Suite
--
-- Auto-localizável: pode ser executada de qualquer cwd
--   lua tests/run.lua
--   lua /caminho/absoluto/tests/run.lua
----------------------------------------------------------

local function locate_root()
  local source = debug.getinfo(1, "S").source
  if source:sub(1, 1) == "@" then
    source = source:sub(2)
  end

  local dir = source:match("^(.*)/[^/]+$") or "."

  -- dir == <root>/tests
  local root = dir:match("^(.*)/tests$")
  if root == nil or root == "" then
    root = dir .. "/.."
  end

  return root
end

local ROOT = locate_root()

package.path = table.concat({
  ROOT .. "/src/lua/?.lua",
  ROOT .. "/src/lua/?/init.lua",
  ROOT .. "/?.lua",
  package.path,
}, ";")

local Helpers = require("tests.framework.helpers")
local Runner = require("tests.framework.runner")

Helpers.set_root(ROOT)

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

-- Fixtures que o próprio Git se recusa a versionar.
Helpers.ensure_fixtures()

for _, suite in ipairs(SUITES) do
  local ok, err = pcall(dofile, ROOT .. "/" .. suite)

  if not ok then
    Runner.fail(suite, "suite não carregou: " .. tostring(err))
  end
end

-- Guarda: todo arquivo em tests/lua/ precisa estar na lista.
-- Sem isto, uma suíte nova esquecida passaria despercebida.
local ok_lfs, lfs = pcall(require, "lfs")

if ok_lfs then
  local listed = {}
  for _, suite in ipairs(SUITES) do
    listed[suite:match("([^/]+)$")] = true
  end

  for entry in lfs.dir(ROOT .. "/tests/lua") do
    if entry:match("%.lua$") and not listed[entry] then
      Runner.fail("tests/lua/" .. entry, "suíte não listada em tests/run.lua")
    end
  end
end

Runner.summary()

if Runner.success() then
  os.exit(0)
end

os.exit(1)
