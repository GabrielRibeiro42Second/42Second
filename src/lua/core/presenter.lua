local Presenter = {}

local function yes_no(value)
  if value then
    return "✔"
  end
  return "✘"
end

local function value_or_dash(value)
  if value == nil or value == "" then
    return "—"
  end
  return tostring(value)
end

local function join_list(items)
  if type(items) ~= "table" or #items == 0 then
    return "—"
  end
  return table.concat(items, ", ")
end

-- Monta o relatório completo. Mantém o prefixo "- " e os
-- textos das sugestões, que são o contrato dos testes.
function Presenter.render(report)
  report = report or {}
  local project = report.project or {}

  local lines = {
    "Relatório: " .. value_or_dash(project.path),
    "─────────────────────────────────────────",
    string.format("Linguagem : %s", value_or_dash(project.language)),
    string.format("Git       : %s", yes_no(project.git)),
    string.format("README    : %s", yes_no(project.readme)),
    string.format("Docker    : %s", yes_no(project.docker)),
    string.format("Layout    : %s", value_or_dash(project.layout)),
    string.format("Plugins   : %s", join_list(project.plugins)),
    "",
    "Sugestões:"
  }

  local suggestions = report.suggestions or {}

  if #suggestions == 0 then
    table.insert(lines, "  (nenhuma — projeto saudável)")
  end

  for _, suggestion in ipairs(suggestions) do
    table.insert(lines, "- " .. suggestion)
  end

  return table.concat(lines, "\n")
end

return Presenter
