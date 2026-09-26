----------------------------------------------------------
-- Filesystem Utils
----------------------------------------------------------

local lfs = require("lfs")

local Filesystem = {}

----------------------------------------------------------
-- Verifica se um arquivo/diretório existe
----------------------------------------------------------

function Filesystem.exists(path)
  if type(path) ~= "string" or path == "" then
    return false
  end

  return lfs.attributes(path) ~= nil
end

----------------------------------------------------------
-- Verifica se o caminho é um diretório (sempre boolean)
----------------------------------------------------------

function Filesystem.is_directory(path)
  if type(path) ~= "string" or path == "" then
    return false
  end

  local attr = lfs.attributes(path)

  return attr ~= nil and attr.mode == "directory"
end

----------------------------------------------------------
-- Lista entradas de um diretório.
-- Retorna uma tabela, ou nil + mensagem de erro.
----------------------------------------------------------

function Filesystem.list(path)
  if not Filesystem.is_directory(path) then
    return nil, "not a directory: " .. tostring(path)
  end

  local ok, iterator, state = pcall(lfs.dir, path)

  if not ok then
    return nil, iterator
  end

  if type(iterator) ~= "function" then
    return nil, tostring(state or iterator)
  end

  local files = {}
  local name = iterator(state)

  while name do
    if name ~= "." and name ~= ".." then
      table.insert(files, name)
    end
    name = iterator(state)
  end

  table.sort(files)

  return files
end

----------------------------------------------------------
-- Procura um arquivo dentro de um diretório e retorna o
-- caminho completo (ou nil).
----------------------------------------------------------

function Filesystem.find(path, filename)
  local files, err = Filesystem.list(path)

  if not files then
    return nil, err
  end

  for _, file in ipairs(files) do
    if file == filename then
      return Filesystem.join(path, filename)
    end
  end

  return nil
end

----------------------------------------------------------
-- Junta partes de um caminho normalizando barras
----------------------------------------------------------

function Filesystem.join(...)
  local parts = { ... }
  local joined = {}

  for index, part in ipairs(parts) do
    part = tostring(part)

    if index == 1 then
      part = part:gsub("/+$", "")
    else
      part = part:gsub("^/+", ""):gsub("/+$", "")
    end

    if part ~= "" then
      table.insert(joined, part)
    end
  end

  if #joined == 0 then
    return "."
  end

  return table.concat(joined, "/")
end

----------------------------------------------------------
-- Retorna o nome do último diretório do caminho
----------------------------------------------------------

function Filesystem.basename(path)
  return tostring(path):match("([^/]+)/*$")
end

return Filesystem
