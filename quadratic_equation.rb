puts "Введите 3 коэффициента:"
a = gets.chomp.to_i
b = gets.chomp.to_i
c = gets.chomp.to_i

d = (b**2 - 4 * a * c) / 2

puts "D = #{d}"

if d > 0
  puts "x1 = #{(-b + Math.sqrt(d)) / (2.0 * a)}"
  puts "x1 = #{(-b - Math.sqrt(d)) / (2.0 * a)}"
elsif d == 0
  puts "x1 = x2 = #{-b / 2.0 * a}"
else
  puts "Корней нет"
end
