require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'station'
require_relative 'route'

class RailRoad
  attr_accessor :trains, :stations, :routes, :wagons

  def initialize
    @trains = []
    @stations = []
    @routes = []
    @wagons = []
    @instructions = {
      1 => 'Создать станцию',
      2 => 'Создать поезд',
      3 => 'Создать маршрут',
      4 => 'Добавить станцию в маршрут',
      5 => 'Удалить станцию из маршрута',
      6 => 'Назначить маршрут поезду',
      7 => 'Добавить вагоны к поезду',
      8 => 'Отцепить вагоны от поезда',
      9 => 'Перемещать поезд по маршруту вперед и назад',
      10 => 'Посмотреть список станций и список поездов на станции',
      11 => 'Выйти'
    }
  end

  def seed
    4.times { |i| @stations << Station.new("Station #{i}") }
    10.times { @wagons << PassengerWagon.new }
    10.times { @wagons << CargoWagon.new }

    @trains << PassengerTrain.new('PTR-11')
    @trains << CargoTrain.new('CTR-12')

    @routes << Route.new(@stations.first, @stations.last)
  end

  def start
    loop do
      show_menu
      user_command = gets.chomp.strip.to_i

      break if user_command == 11

      (1..10).include?(user_command) ? perform(user_command) : start
    end
  end

  def show_menu
    puts "Введите команду:"
    @instructions.each { |k, v| puts "#{k}. #{v}" }
  end

  def perform(user_command)
    case user_command
    when 1 then create_station
    when 2 then create_train
    when 3 then create_route
    when 4 then add_station
    when 5 then remove_station
    when 6 then assign_route
    when 7 then attach_wagon
    when 8 then detach_wagon
    when 9 then move_train
    when 10 then show_stations_with_trains
    end
  end

  def create_station
    puts "Введите название станции:"
    name = gets.chomp.strip
    create_station!(name)
  end

  def create_train
    puts "Выберите тип поезда: 1. Пассажирский  2. Грузовой"
    type_index = gets.chomp.strip.to_i

    puts "Введите номер поезда:"
    number = gets.chomp.strip

    create_train!(type_index, number)
  end

  def create_route
    stations = []
    2.times { stations << get_station }
    create_route!(stations)
  end

  def add_station
    route = get_route
    station = get_station

    if route && station
      route.add_station(station)
      puts "Станция добавлена."
    else
      puts "Произошла ошибка."
    end
  end

  def remove_station
    route = get_route
    station = get_station(route.stations) if route

    if station
      route.delete_station(station)
      puts "Станция удалена."
    else
      puts "Произошла ошибка."
    end
  end

  def assign_route
    train = get_train
    route = get_route

    if train && route
      train.assign_route(route)
      puts "Маршрут назначен."
    else
      puts "Произошла ошибка."
    end
  end

  def attach_wagon
    train = get_train
    wagon = get_wagon(train.type) if train

    if wagon
      train.hook(wagon)
      @wagons.delete(wagon)
      puts "Вагон добавлен."
    else
      puts "Произошла ошибка."
    end
  end

  def detach_wagon
    train = get_train
    wagon = train.wagons.last if train && train&.wagons&.count > 0

    if wagon
      train.unhook(wagon)
      @wagons << wagon
      puts "Вагон отцеплен от поезда."
    else
      puts "Произошла ошибка."
    end
  end

  def move_train
    train = get_train
    direction = get_direction(train) if train && train&.route

    if direction
      train.send(direction)
      puts "Поезд перемещен."
    else
      puts "Произошла ошибка."
    end
  end

  def show_stations_with_trains
    @stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name.upcase}:"
      station.show_trains_list
    end
  end

  private

  def create_station!(name)
    station = Station.new(name)

    if station.message.nil?
      @stations << station
      puts "Станция #{name} создана."
    else
      puts station.message
      create_station
    end
  end

  def create_train!(type_index, number)
    return puts "Выбран неверный тип." unless [1, 2].include?(type_index)
    train = type_index == 1 ? PassengerTrain.new(number) : CargoTrain.new(number)

    if train.message.nil?
      @trains << train
      puts "Поезд #{number} создан."
    else
      puts train.message
      create_train
    end
  end

  def create_route!(stations)
    route = Route.new(stations[0], stations[1])

    if route.message.nil?
      @routes << route
      puts "Маршрут #{route.name} создан."
    else
      puts route.message
      create_route
    end
  end

  def get_station(stations = @stations)
    return nil if stations.empty?

    puts "Выберите станцию:"
    stations.each.with_index(1) { |station, index| puts "#{index}. #{station.name}"}
    index = gets.chomp.strip.to_i

    index == 0 ? nil : stations[index - 1]
  end

  def get_route
    return nil if @routes.empty?
    puts "Выберите маршрут:"
    @routes.each.with_index(1) { |route, index| puts "#{index}. #{route.name}"}
    index = gets.chomp.strip.to_i
    index == 0 ? nil : @routes[index - 1]
  end

  def get_train
    puts "Выберите поезд:"
    @trains.each.with_index(1) { |train, index| puts "#{index}. #{train.number}" }
    index = gets.chomp.strip.to_i
    index == 0 ? nil : @trains[index - 1]
  end

  def get_wagon(train_type)
    wagons = @wagons.select { |wagon| wagon.type == train_type }
    wagons.empty? ? nil : wagons.first
  end

  def get_direction(train)
    puts "Выберите направление:"
    puts "1. вперед: #{train.next_station.name}" if train.next_station
    puts "2. назад: #{train.previous_station.name}" if train.previous_station
    index = gets.chomp.strip.to_i

    case index
    when 1
      'move_forward'
    when 2
      'move_back'
    else
      nil
    end
  end
end

rr = RailRoad.new
rr.seed
rr.start
