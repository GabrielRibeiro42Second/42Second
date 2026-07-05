local Scanner = require("core.scanner")

local Inspector = {}

function Inspector.inspect(path)
  return Scanner.scan(path)
end

return Inspector
