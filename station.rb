class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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
end
