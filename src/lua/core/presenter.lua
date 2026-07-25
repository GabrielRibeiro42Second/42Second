local Presenter = {}

function Presenter.render(report)
  local texto = "Sugestão:"

  for _, suggestion in ipairs(report.suggestions) do
    texto = texto .. "- " .. suggestion .. "\n"
  end
  return texto
end

return Presenter
