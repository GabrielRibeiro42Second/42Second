local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Presenter = require("core.presenter")
local Inspector = require("core.inspector")
local Project = require("models.project")

local function report()
  return Inspector.inspect(Project.new())
end

Runner.run("Presenter.render returns a string", function()
  Assert.is_equals("string", type(Presenter.render(report())))
end)

Runner.run("Presenter.render lists every suggestion", function()
  local output = Presenter.render(report())

  Assert.isnot_nil(
    output:find("Projeto não possui README.md.", 1, true)
  )
  Assert.isnot_nil(
    output:find("Projeto não possui Git.", 1, true)
  )
end)

-- Formatação exata: é isto que impede regressões como um
-- cabeçalho colado no primeiro item ("Sugestão:- ...").
Runner.run("Presenter.render formats the report exactly", function()
  local project = Project.new()
  project.path = "/tmp/demo"

  local output = Presenter.render(Inspector.inspect(project))

  Assert.is_equals(table.concat({
    "Relatório: /tmp/demo",
    "─────────────────────────────────────────",
    "Linguagem : —",
    "Git       : ✘",
    "README    : ✘",
    "Docker    : ✘",
    "Layout    : —",
    "Plugins   : —",
    "",
    "Sugestões:",
    "- Projeto não possui README.md.",
    "- Projeto não possui Git.",
  }, "\n"), output)
end)

Runner.run("Presenter.render reports a healthy project", function()
  local project = Project.new()
  project.path = "/tmp/healthy"
  project.language = "go"
  project.git = true
  project.readme = true
  project.docker = true

  local output = Presenter.render(Inspector.inspect(project))

  Assert.is_nil(output:find("Projeto não possui", 1, true))
  Assert.isnot_nil(output:find("(nenhuma — projeto saudável)", 1, true))
  Assert.isnot_nil(output:find("Git       : ✔", 1, true))
  Assert.isnot_nil(output:find("Linguagem : go", 1, true))
end)
