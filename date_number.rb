puts "Введите число дня, месяц и год:"
day = gets.chomp.to_i
month = gets.chomp.to_i
year = gets.chomp.to_i

unless month == 1
  months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  is_leap_year = ( year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0
  days = months[0..(month - 2)].inject(&:+) + day
  day = ((month == 2 && day == 29) || month > 2) && is_leap_year ? days + 1 : days
end

p "Порядковый номер даты: #{day}"
