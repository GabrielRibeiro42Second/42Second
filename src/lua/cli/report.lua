----------------------------------------------------------
-- termOS report — CLI do pipeline Lua
--
--   lua src/lua/cli/report.lua [diretorio]
----------------------------------------------------------

local Orchestrator = require("core.orchestrator")

local path = (arg and arg[1]) or "."

io.write(Orchestrator.run(path))
io.write("\n")
