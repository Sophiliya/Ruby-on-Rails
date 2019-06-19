puts "Введите имя:"
name = gets.chomp
puts "Введите ваш рост:"
height = gets.chomp.to_i

ideal_weight = height - 110
puts ideal_weight > 0 ? "Ваш идеальный вес #{ideal_weight}." : "Ваш вес уже оптимальный."
