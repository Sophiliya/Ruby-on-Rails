class Train
  attr_reader :number, :type, :wagons, :speed, :route, :current_station

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def increase_speed
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def hook(wagon)
    @wagons << wagon if @speed.zero?
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

  protected

  # это вспомогательный метод, который не должен вызываться напрямую юзером
  # но может вызываться у наследованных классов
  def move_to(target_station)
    @current_station.send_train(self)
    target_station.get_train(self)
    @current_station = target_station
  end
end
