local Scanner = require("core.scanner")

-- Se nenhum caminho for informado, usa o diretório atual.
local path = arg[1] or "."

local project = Scanner.scan(path)

print("Path      :", project.path)
print("Language  :", project.language)
