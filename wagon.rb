require_relative 'manufacturer_company'
require_relative 'instance_counter'

class Wagon
  extend InstanceCounter::ClassMethods
  include InstanceCounter::InstanceMethods
  include ManufacturerCompany

  attr_reader :type

  def initialize
    register_instance
  end
end
