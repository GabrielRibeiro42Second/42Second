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

local NAME_WIDTH = 46

local function write_name(name)
  io.write(name)
  local padding = NAME_WIDTH - #name
  if padding < 1 then
    padding = 1
  end
  io.write(string.rep(" ", padding))
end

----------------------------------------------------------
-- Executa um teste
----------------------------------------------------------

function Runner.run(name, test)
  Runner.total = Runner.total + 1

  write_name(name)

  local success, err = pcall(test)

  if success then
    Runner.passed = Runner.passed + 1
    print("[ OK ]")
    return true
  end

  Runner.failed = Runner.failed + 1

  print("[FAIL]")
  print(tostring(err))

  return false
end

----------------------------------------------------------
-- Registra uma falha fora do contexto de um teste
-- (suite que não carregou, arquivo esquecido, etc.)
----------------------------------------------------------

function Runner.fail(name, message)
  return Runner.run(name, function()
    error(message, 0)
  end)
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
-- Indica se houve falhas.
-- Zero testes NÃO é sucesso: uma suíte que nunca rodou
-- tem que quebrar o build.
----------------------------------------------------------

function Runner.success()
  if Runner.total == 0 then
    print("Nenhum teste executado.")
    return false
  end

  return Runner.failed == 0
end

return Runner
