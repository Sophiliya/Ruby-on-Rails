# frozen_string_literal: true

require_relative 'manufacturer_company'
require_relative 'instance_counter'

class Wagon
  include InstanceCounter
  include ManufacturerCompany

  attr_reader :type
end
