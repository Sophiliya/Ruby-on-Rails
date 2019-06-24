class Train
  attr_reader :number, :type, :number_of_wagons, :speed, :route, :current_station

  def initialize(number, type, number_of_wagons)
    @number = number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = 0
  end

  def increase_speed
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def hook_wagon
    @number_of_wagons += 1 if @speed == 0
  end

  def unhook
    @number_of_wagons -= 1 if @speed == 0 && @number_of_wagons > 1
  end

  def assign_route(route)
    @route = route
    @route.stations.first.get_train(self)
    @current_station = @route.stations.first
  end

  def next_station
    @route.stations[@route.stations.index(@current_station) + 1]
  end

  def previous_station
    stations = @route.stations
    index = stations.index(@current_station)
    @current_station == stations.first ? nil : stations[index - 1]
  end

  def move_forward
    if next_station
      @current_station.send_train(self)
      next_station.get_train(self)
      @current_station = next_station
    end
  end

  def move_back
    if previous_station
      @current_station.send_train(self)
      previous_station.get_train(self)
      @current_station = previous_station
    end
  end
end
