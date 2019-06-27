class PassengerTrain < Train
  def hook(wagon)
    super if wagon_attachable?(wagon)
  end

  private

  def wagon_attachable?(wagon)
    wagon.class == PassengerWagon
  end
end
