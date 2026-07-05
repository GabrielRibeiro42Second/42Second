local Assert = require("tests.framework.assert")

print("Teste 1")
Assert.is_equals(10, 10)

print("Teste 2")
Assert.is_true(true)

print("Teste 3")
Assert.is_false(false)

print("Teste 4")
Assert.isnot_nil("termOS")

print("Tudo funcionando!")
