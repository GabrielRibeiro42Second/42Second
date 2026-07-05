local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")

local Filesystem = require("utils.filesystem")

Runner.run("Filesystem.exists()", function()
  Assert.is_true(
    Filesystem.exists("README.md")
  )
end)

Runner.run("Filesystem.exists() inexistente", function()
  Assert.is_false(
    Filesystem.exists("arquivo_inexistente.txt")
  )
end)

Runner.run("Filesystem.list()", function()
  local files = Filesystem.list(".")

  Assert.is_true(
    #files > 0
  )
end)
