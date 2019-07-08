require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations, :start, :finish, :message

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [@start, @finish]
    return @message unless valid?
    register_instance
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
    begin
      validate!
      true
    rescue StandardError => message
      @message = message
      false
    end
  end

  def validate!
    if @start.class.to_s != 'Station' || @finish.class.to_s != 'Station'
      raise "Типы переменных не соответствуют классу Station"
    end 
  end
end
