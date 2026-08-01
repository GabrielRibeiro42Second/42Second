local Tui = require("utils.tui")
local Assert = require("tests.framework.assert")

local display = Tui.display()

Assert.is_equals("string", display)
