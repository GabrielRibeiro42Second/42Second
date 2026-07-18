local Inspector = require("core.inspector")
local Presenter = {}

function Presenter.render(report)
  local texto = "Sugestão:"

  for _, suggestion in ipairs(report.suggestions) do
    texto = "- " .. suggestion .. "\n"
    return texto
  end
end

return Presenter
