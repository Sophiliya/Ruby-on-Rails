# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains, :message
  validate :name, :presence

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name

    if valid?
      @trains = []
      @@stations << self
      register_instance
    end
  end

  def get_train(train)
    @trains << train
  end

  def trains_by_type(type)
    return if @trains.empty?

    @trains.select { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train) if @trains.include?(train)
  end

  def show_trains_list
    return puts 'На станции нет поездов.' if @trains.empty?

    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number} - #{train.class}"
    end
  end

  def each_train
    return if @trains.empty?

    @trains.each { |train| yield(train) }
  end
end
