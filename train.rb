# frozen_string_literal: true

require_relative 'manufacturer_company'
require_relative 'instance_counter'

class Train
  include InstanceCounter
  include ManufacturerCompany

  attr_reader :number, :wagons, :speed, :route, :current_station, :type, :message

  NUMBER_FORMAT = /^[0-9a-z]{3}-?[0-9a-z]{2}$/i.freeze

  @@trains = {}

  def self.find(train_number)
    @@trains.find { |train| train.number == train_number }
  end

  def initialize(number)
    @number = number
    return @message unless valid?

    @wagons = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def increase_speed
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def hook(wagon)
    @wagons << wagon if wagon_attachable?(wagon)
  end

  def unhook(wagon)
    @wagons.delete(wagon) if @speed.zero? && @wagons.include?(wagon)
  end

  def assign_route(route)
    @route = route
    @route.stations.first.get_train(self)
    @current_station = @route.stations.first
  end

  def next_station
    stations = @route.stations
    index = stations.index(@current_station)
    @current_station == stations.last ? nil : stations[index + 1]
  end

  def previous_station
    stations = @route.stations
    index = stations.index(@current_station)
    @current_station == stations.first ? nil : stations[index - 1]
  end

  def move_forward
    return unless next_station

    move_to(next_station)
  end

  def move_back
    return unless previous_station

    move_to(previous_station)
  end

  def each_wagon
    return if @wagons.empty?

    @wagons.each { |wagon| yield(wagon) }
  end

  protected

  def valid?
    validate!
    true
  rescue StandardError => e
    @message = e
    false
  end

  def validate!
    if number.empty? || number.nil?
      raise 'Номер не может быть пустым'
    elsif number !~ NUMBER_FORMAT
      raise 'Номер не соответствует формату'
    end
  end

  def move_to(target_station)
    @current_station.send_train(self)
    target_station.get_train(self)
    @current_station = target_station
  end

  def wagon_attachable?(wagon)
    wagon.type == type && @speed.zero?
  end
end
