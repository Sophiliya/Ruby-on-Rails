# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :start, :finish, :message
  validate :start, :type, Station
  validate :finish, :type, Station

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = []

    if valid?
      @stations << @start
      @stations << @finish
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
end
