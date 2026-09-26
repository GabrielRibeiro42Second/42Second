local Runner = require("tests.framework.runner")
local Assert = require("tests.framework.assert")
local Scanner = require("core.scanner")
local Tui = require("utils.tui")

Runner.run("requiring utils.tui does not scan a project", function()
  local original = Scanner.scan
  local calls = 0
  Scanner.scan = function(...)
    calls = calls + 1
    return original(...)
  end

  package.loaded["utils.tui"] = nil
  local ok, err = pcall(require, "utils.tui")

  Scanner.scan = original

  if not ok then
    error(err, 0)
  end

  Assert.is_equals(0, calls)
end)

Runner.run("Tui.display prints the given output", function()
  local printed
  local original = print

  print = function(first)
    printed = first
  end

  local ok, err = pcall(Tui.display, "hello")

  print = original

  if not ok then
    error(err, 0)
  end

  Assert.is_equals("hello", printed)
end)
