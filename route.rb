require_relative 'instance_counter'

class Route
  extend InstanceCounter::ClassMethods
  include InstanceCounter::InstanceMethods

  attr_reader :stations, :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [@start, @finish]
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
end
