local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")

Runner.run("Assert equals", function()
  Assert.is_equals(10, 10)
end)

Runner.run("Assert true", function()
  Assert.is_true(true)
end)

Runner.run("Assert false", function()
  Assert.is_false(false)
end)

Runner.run("Erro proposital", function()
  Assert.is_equals("java", "python")
end)
