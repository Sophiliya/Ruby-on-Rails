# frozen_string_literal: true

require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations, :start, :finish, :message

  def initialize(start, finish)
    @start = start
    @finish = finish

    if valid?
      @stations = [@start, @finish]
      register_instance
    end
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if @stations.include?(station)
  end

  def name
    "#{start.name} - #{finish.name}"
  end

  private

  def valid?
    validate!
    true
  rescue StandardError => e
    @message = e
    false
  end

  def validate!
    stations = @start.class == Station && @finish.class == Station
    raise 'Типы переменных не соответствуют классу Station' unless stations
  end
end
