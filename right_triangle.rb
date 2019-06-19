sides = []
puts "Первая сторона треугольника:"
sides << gets.chomp.to_i
puts "Вторая сторона треугольника:"
sides << gets.chomp.to_i
puts "Третья сторона треугольника:"
sides << gets.chomp.to_i

sides.sort!

is_isosceles = sides.uniq.count == 2
is_equilateral = sides.uniq.count == 1
is_right = sides[0]**2 + sides[1]**2 == sides[2]**2

if is_equilateral
  puts "Треугольник равнобедренный и равносторонний, но не прямоугольный"
elsif is_right && !is_isosceles
  puts "Треугольник прямоугольный"
elsif !is_right && is_isosceles
  puts "Треугольник равнобедренный, но не прямоугольный"
elsif is_right && is_isosceles
  puts "Треугольник прямоугольный и равнобедренный"
else
  puts "Треугольник обычный"
end
