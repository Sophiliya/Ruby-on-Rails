class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end

  def hook(wagon)
    super if wagon_attachable?(wagon)
  end

  private

  def wagon_attachable?(wagon)
    wagon.class == CargoWagon
  end
end
