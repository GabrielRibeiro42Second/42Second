local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Helpers = require("tests.framework.helpers")

local Filesystem = require("utils.filesystem")

local readme = Helpers.fixture("readme")

Runner.run("Filesystem.exists()", function()
  Assert.is_true(
    Filesystem.exists(readme .. "/README.md")
  )
end)

Runner.run("Filesystem.exists() inexistente", function()
  Assert.is_false(
    Filesystem.exists(readme .. "/arquivo_inexistente.txt")
  )
end)

Runner.run("Filesystem.exists() rejeita entrada inválida", function()
  Assert.is_false(Filesystem.exists(nil))
  Assert.is_false(Filesystem.exists(""))
end)

Runner.run("Filesystem.list()", function()
  local files = Filesystem.list(readme)

  Assert.is_true(
    #files > 0
  )
end)

Runner.run("Filesystem.list() em diretório inexistente", function()
  local files, err = Filesystem.list(readme .. "/nao_existe")

  Assert.is_nil(files)
  Assert.isnot_nil(err)
end)

Runner.run("Filesystem.list() em arquivo", function()
  local files, err = Filesystem.list(readme .. "/README.md")

  Assert.is_nil(files)
  Assert.isnot_nil(err)
end)

Runner.run("Filesystem.is_directory() devolve boolean", function()
  Assert.is_true(Filesystem.is_directory(readme))
  Assert.is_false(Filesystem.is_directory(readme .. "/README.md"))
  Assert.is_false(Filesystem.is_directory(readme .. "/nao_existe"))
end)

Runner.run("Filesystem.find() devolve o caminho completo", function()
  Assert.is_equals(
    readme .. "/README.md",
    Filesystem.find(readme, "README.md")
  )
end)

Runner.run("Filesystem.find() devolve nil quando ausente", function()
  Assert.is_nil(Filesystem.find(readme, "INEXISTENTE.md"))
end)

Runner.run("Filesystem.join() normaliza barras", function()
  Assert.is_equals("a/b/c", Filesystem.join("a", "b", "c"))
  Assert.is_equals("a/b/c", Filesystem.join("a/", "/b", "c/"))
  Assert.is_equals("/a/b", Filesystem.join("/a", "b"))
  Assert.is_equals("a", Filesystem.join("a", ""))
end)

Runner.run("Filesystem.basename()", function()
  Assert.is_equals("c", Filesystem.basename("/a/b/c"))
  Assert.is_equals("c", Filesystem.basename("/a/b/c/"))
end)
