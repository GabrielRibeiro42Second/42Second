local Inspector = {}

-- Sugestões são lacunas acionáveis de saúde do projeto.
-- Informativos (linguagem, docker, layout, plugins) são
-- apresentados pelo Presenter, não entram aqui.
local SUGGESTIONS = {
  {
    check = function(project) return not project.readme end,
    text  = "Projeto não possui README.md."
  },
  {
    check = function(project) return not project.git end,
    text  = "Projeto não possui Git."
  },
}

function Inspector.inspect(project)
  local report = {
    project = project,
    suggestions = {}
  }

  for _, suggestion in ipairs(SUGGESTIONS) do
    if suggestion.check(project) then
      table.insert(report.suggestions, suggestion.text)
    end
  end

  return report
end

return Inspector
