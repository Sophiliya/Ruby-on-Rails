require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains, :message

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    return @message unless valid?
    @trains = []
    @@stations << self
    register_instance
  end

  def get_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type } unless @trains.empty?
  end

  def send_train(train)
    @trains.delete(train) if @trains.include?(train)
  end

  def show_trains_list
    return puts "На станции нет поездов." if @trains.empty?

    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number} - #{train.class}"
    end
  end

  def each_train
    return if @trains.empty?

    @trains.each do |train|
      yield(train)
    end
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
    if name.nil? || name.empty?
      raise "Название станции не может быть пустым"
    end
  end
end
