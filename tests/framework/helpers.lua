----------------------------------------------------------
-- Test Helpers
----------------------------------------------------------

local Helpers = {}

----------------------------------------------------------
-- Retorna o caminho absoluto do projeto
----------------------------------------------------------

function Helpers.root()
  return "."
end

----------------------------------------------------------
-- Retorna o caminho de uma fixture
----------------------------------------------------------

function Helpers.fixture(name)
  return Helpers.root() .. "/tests/fixtures/" .. name
end

----------------------------------------------------------
-- Imprime um cabeçalho
----------------------------------------------------------

function Helpers.header(title)
  print()
  print(string.rep("-", 60))
  print(title)
  print(string.rep("-", 60))
end

----------------------------------------------------------
-- Imprime uma linha
----------------------------------------------------------

function Helpers.line()
  print(string.rep("-", 60))
end

return Helpers
