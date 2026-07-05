----------------------------------------------------------
-- Test Runner
----------------------------------------------------------

local Runner = {}

----------------------------------------------------------
-- Estatísticas
----------------------------------------------------------

Runner.total = 0
Runner.passed = 0
Runner.failed = 0

----------------------------------------------------------
-- Executa um teste
----------------------------------------------------------

function Runner.run(name, test)
  Runner.total = Runner.total + 1

  io.write(string.format("%-30s", name))

  local success, err = pcall(test)

  if success then
    Runner.passed = Runner.passed + 1
    print("[ OK ]")
    return true
  end

  Runner.failed = Runner.failed + 1

  print("[FAIL]")
  print(err)

  return false
end

----------------------------------------------------------
-- Exibe o resumo
----------------------------------------------------------

function Runner.summary()
  print()
  print(string.rep("-", 60))
  print("Tests : " .. Runner.total)
  print("Passed: " .. Runner.passed)
  print("Failed: " .. Runner.failed)
  print(string.rep("-", 60))
end

----------------------------------------------------------
-- Indica se houve falhas
----------------------------------------------------------

function Runner.success()
  return Runner.failed == 0
end

return Runner
