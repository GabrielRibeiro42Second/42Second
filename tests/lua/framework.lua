local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")

local function rejected(fn)
  local ok, err = pcall(fn)
  return not ok
    and tostring(err):find("Assertion failed", 1, true) ~= nil
end

Runner.run("Assert.is_equals accepts equal values", function()
  Assert.is_equals(10, 10)
end)

Runner.run("Assert.is_equals rejects different values", function()
  Assert.is_true(rejected(function()
    Assert.is_equals("java", "python")
  end))
end)

Runner.run("Assert.is_true rejects false", function()
  Assert.is_true(rejected(function()
    Assert.is_true(false)
  end))
end)

Runner.run("Assert.is_false rejects true", function()
  Assert.is_true(rejected(function()
    Assert.is_false(true)
  end))
end)

Runner.run("Assert.is_nil rejects a value", function()
  Assert.is_true(rejected(function()
    Assert.is_nil("termOS")
  end))
end)

Runner.run("Assert.isnot_nil rejects nil", function()
  Assert.is_true(rejected(function()
    Assert.isnot_nil(nil)
  end))
end)

Runner.run("Assert.isnot_nil accepts a value", function()
  Assert.isnot_nil("termOS")
end)
