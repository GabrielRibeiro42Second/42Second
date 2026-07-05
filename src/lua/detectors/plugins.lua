local Filesystem = require("utils.filesystem")

local PluginsDetector = {}

function PluginsDetector.detect(path)
  local plugins = {}

  local plugins_path = Filesystem.join(
    path,
    ".termos",
    "plugins"
  )

  if not Filesystem.is_directory(plugins_path) then
    return plugins
  end

  for _, file in ipairs(Filesystem.list(plugins_path)) do
    table.insert(plugins, file)
  end

  return plugins
end

return PluginsDetector
