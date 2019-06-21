puts "Введите число дня, месяц и год:"
day = gets.chomp.to_i
month = gets.chomp.to_i
year = gets.chomp.to_i

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
is_leap_year = ( year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0

days = month > 1 ? months.take(month - 1).sum + day : day
days += 1 if month > 2 && is_leap_year

p "Порядковый номер даты: #{days}"
