goods = {}
price_count = {}

loop do
  puts 'Введите название товара:'
  product = gets.chomp.downcase

  break if product == "стоп"

  puts 'цена:'
  price = gets.chomp.to_f

  puts 'количество/вес:'
  count = gets.chomp.to_f

  goods[product] = { price: price, amount: count }
end

p goods

total = 0

goods.each do |product, price_count|
  sum = price_count[:price] * price_count[:amount]
  total += sum
  p "#{product} = #{sum}"
end

p "Total: #{total}."
