----------------------------------------------------------
-- Assert Framework
----------------------------------------------------------

local Assert = {}

----------------------------------------------------------
-- Verifica igualdade entre dois valores
----------------------------------------------------------

function Assert.is_equals(expected, actual)
  if expected ~= actual then
    error(
      string.format(
        "Assertion failed\nExpected: %s\nActual:   %s",
        tostring(expected),
        tostring(actual)
      ),
      2
    )
  end
end

----------------------------------------------------------
-- Verifica se um valor é verdadeiro
----------------------------------------------------------

function Assert.is_true(value)
  Assert.is_equals(true, value)
end

----------------------------------------------------------
-- Verifica se um valor é falso
----------------------------------------------------------

function Assert.is_false(value)
  Assert.is_equals(false, value)
end

----------------------------------------------------------
-- Verifica se um valor é nil
----------------------------------------------------------

function Assert.is_nil(value)
  Assert.is_equals(nil, value)
end

----------------------------------------------------------
-- Verifica se um valor NÃO é nil
----------------------------------------------------------

function Assert.isnot_nil(value)
  if value == nil then
    error(
      "Assertion failed\nExpected a value but got nil",
      2
    )
  end
end

return Assert
