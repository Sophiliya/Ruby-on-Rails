class PassengerWagon < Wagon
  attr_reader :number_of_seats, :seats_available, :seats_occupied

  def initialize(number_of_seats)
    @type = :passenger
    @number_of_seats = number_of_seats
    @seats_available = number_of_seats
    @seats_occupied = 0
    register_instance
  end

  def occupy_seat
    return if @seats_available.zero?

    @seats_available -= 1
    @seats_occupied += 1
  end
end
