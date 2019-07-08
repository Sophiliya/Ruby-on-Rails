# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :volume, :volume_available, :volume_occupied

  def initialize(volume)
    @type = :cargo
    @volume = volume
    @volume_available = volume
    @volume_occupied = 0
    register_instance
  end

  def take_volume(volume)
    return if @volume_available.zero?

    @volume_available -= volume
    @volume_occupied += volume
  end
end
