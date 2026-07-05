local Filesystem = require("utils.filesystem")

local files = Filesystem.list(".")

for _, file in ipairs(files) do
  print(file)
end
