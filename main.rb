# frozen_string_literal: true

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

  def start
    loop do
      show_menu
      user_command = gets.chomp.strip.to_i

      break if user_command == 11

      (1..10).include?(user_command) ? perform(user_command) : start
    end
  end

  def show_menu
    puts 'Введите команду:'
    @instructions.each { |k, v| puts "#{k}. #{v}" }
  end

  def perform(user_command)
    tasks = {
      1 => 'create_station', 2 => 'create_train', 3 => 'create_route',
      4 => 'add_station', 5 => 'remove_station', 6 => 'assign_route',
      7 => 'attach_wagon', 8 => 'detach_wagon', 9 => 'move_train',
      10 => 'stations_trains_info'
    }

    send(tasks[user_command])
  end

  def create_station
    puts 'Введите название станции:'
    name = gets.chomp.strip
    create_station!(name)
  end

  def create_train
    puts 'Выберите тип поезда: 1. Пассажирский  2. Грузовой'
    type_index = gets.chomp.strip.to_i

    puts 'Введите номер поезда:'
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
      puts 'Станция добавлена.'
    else
      puts 'Произошла ошибка.'
    end
  end

  def remove_station
    route = get_route
    station = get_station(route.stations) if route

    if station
      route.delete_station(station)
      puts 'Станция удалена.'
    else
      puts 'Произошла ошибка.'
    end
  end

  def assign_route
    train = get_train
    route = get_route

    if train && route
      train.assign_route(route)
      puts 'Маршрут назначен.'
    else
      puts 'Произошла ошибка.'
    end
  end

  def attach_wagon
    train = get_train
    wagon = get_wagon(train.type)

    if train && wagon
      train.hook(wagon)
      @wagons.delete(wagon)
      puts 'Вагон добавлен.'
    else
      puts 'Произошла ошибка.'
    end
  end

  def detach_wagon
    train = get_train
    wagon = train.wagons.last

    if train && wagon
      train.unhook(wagon)
      @wagons << wagon
      puts 'Вагон отцеплен от поезда.'
    else
      puts 'Произошла ошибка.'
    end
  end

  def move_train
    train = get_train
    direction = get_direction(train) if train && train&.route

    if direction
      train.send(direction)
      puts 'Поезд перемещен.'
    else
      puts 'Произошла ошибка.'
    end
  end

  def stations_trains_info
    @stations.each do |station|
      puts "#{station.name}:"

      station.each_train do |train|
        get_info[:train].call(train)

        train_wagons_info(train)
      end
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

  def create_train!(type_id, number)
    return puts 'Выбран неверный тип.' unless [1, 2].include?(type_id)

    train = type_id == 1 ? PassengerTrain.new(number) : CargoTrain.new(number)

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
    return if stations.empty?

    puts 'Выберите станцию:'
    stations.each.with_index(1) { |station, i| puts "#{i}. #{station.name}" }
    i = gets.chomp.strip.to_i

    i.zero? ? nil : stations[i - 1]
  end

  def get_route
    return nil if @routes.empty?

    puts 'Выберите маршрут:'
    @routes.each.with_index(1) { |route, index| puts "#{index}. #{route.name}" }
    i = gets.chomp.strip.to_i
    i.zero? ? nil : @routes[i - 1]
  end

  def get_train
    puts 'Выберите поезд:'
    @trains.each.with_index(1) { |train, i| puts "#{i}. #{train.number}" }
    i = gets.chomp.strip.to_i
    i.zero? ? nil : @trains[i - 1]
  end

  def get_wagon(train_type)
    wagons = @wagons.select { |wagon| wagon.type == train_type }
    wagons.empty? ? nil : wagons.first
  end

  def get_direction(train)
    puts 'Выберите направление:'
    puts "1. вперед: #{train.next_station.name}" if train.next_station
    puts "2. назад: #{train.previous_station.name}" if train.previous_station

    index = gets.chomp.strip.to_i
    return 'move_forward' if index == 1
    return 'move_back' if index == 2
  end

  def get_info
    train_info = ->(t) { puts " - #{t.number}, #{t.class}, #{t.wagons.count}" }
    wagon_info = lambda do |w, i|
      available = w.type == :cargo ? w.volume_available : w.seats_available
      occupied = w.type == :cargo ? w.volume_occupied : w.seats_occupied
      puts "  - #{i}, #{w.type}, #{available}, #{occupied}"
    end

    { train: train_info, wagon: wagon_info }
  end

  def train_wagons_info(train)
    i = 1

    while i <= train.wagons.count
      train.each_wagon do |wagon|
        get_info[:wagon].call(wagon, i)
        i += 1
      end
    end
  end
end

rr = RailRoad.new

4.times { |i| rr.stations << Station.new("Station #{i}") }
3.times do |i|
  rr.trains << PassengerTrain.new("PTR-1#{i}")
  rr.trains << CargoTrain.new("CTR-2#{i}")
end
10.times { rr.wagons << PassengerWagon.new(50) }
10.times { rr.wagons << CargoWagon.new(20) }

3.times { rr.trains[0].hook(rr.wagons.first) }
3.times { rr.trains.last.hook(rr.wagons.last) }

rr.routes << Route.new(rr.stations.first, rr.stations.last)
3.times { |i| rr.trains[i].assign_route(rr.routes.first) }

rr.start
