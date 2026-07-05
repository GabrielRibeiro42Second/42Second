local Workspace = require("models.workspace")

local workspace = Workspace.new()

workspace.name = "java-roadmap"
workspace.language = "java"

print(workspace.name)
print(workspace.language)
print(workspace.git)
