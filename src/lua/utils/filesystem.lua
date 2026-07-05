----------------------------------------------------------
-- Filesystem Utils
----------------------------------------------------------

local lfs = require("lfs")

local Filesystem = {}



----------------------------------------------------------
-- Verifica se um arquivo existe
----------------------------------------------------------

function Filesystem.exists(path)
  return lfs.attributes(path) ~= nil
end

function Filesystem.is_directory(path)
  local attr = lfs.attributes(path)

  return attr and attr.mode == "directory"
end

function Filesystem.list(path)
  local files = {}

  for file in lfs.dir(path) do
    if file ~= "." and file ~= ".." then
      table.insert(files, file)
    end
  end

  return files
end

----------------------------------------------------------
-- Procura um arquivo dentro de um diretório
----------------------------------------------------------

function Filesystem.find(path, filename)
  for _, file in ipairs(Filesystem.list(path)) do
    if file == filename then
      return file
    end
  end

  return nil
end

----------------------------------------------------------
-- Junta partes de um caminho
----------------------------------------------------------

function Filesystem.join(...)
  local parts = { ... }

  return table.concat(parts, "/")
end

----------------------------------------------------------
-- Retorna o nome do último diretório do caminho
----------------------------------------------------------

function Filesystem.basename(path)
  return path:match("([^/]+)/*$")
end

return Filesystem
