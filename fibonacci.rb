fibonacci = []
number = 0

while number < 100 do
  fibonacci << number
  number += number == 0 ? 1 : fibonacci[-2]
end

p fibonacci
