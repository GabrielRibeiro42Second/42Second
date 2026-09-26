----------------------------------------------------------
-- Test Helpers
----------------------------------------------------------

local Helpers = {}

local lfs = require("lfs")

local root = "."

----------------------------------------------------------
-- Define a raiz do projeto (chamada por tests/run.lua)
----------------------------------------------------------

function Helpers.set_root(value)
  root = value
end

----------------------------------------------------------
-- Retorna o caminho absoluto do projeto
----------------------------------------------------------

function Helpers.root()
  return root
end

----------------------------------------------------------
-- Retorna o caminho de uma fixture
----------------------------------------------------------

function Helpers.fixture(name)
  return root .. "/tests/fixtures/" .. name
end

----------------------------------------------------------
-- Cria fixtures que o Git não consegue versionar.
--
-- Git recusa qualquer caminho com um componente `.git`,
-- então o marcador do fixture "git" precisa ser gerado
-- em tempo de execução — senão um clone limpo falharia.
----------------------------------------------------------

function Helpers.ensure_fixtures()
  local git_fixture = Helpers.fixture("git")
  local marker = git_fixture .. "/.git"

  pcall(lfs.mkdir, git_fixture)

  if lfs.attributes(marker) == nil then
    local handle = io.open(marker, "w")
    if handle then
      handle:write("# marcador sintético de repositório\n")
      handle:write("# (gerado por tests/run.lua — Git não versiona caminhos .git)\n")
      handle:close()
    end
  end

  return lfs.attributes(marker) ~= nil
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
