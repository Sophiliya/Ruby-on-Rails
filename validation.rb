module Validation
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def validate(attribute, type, format = nil)
      case type
      when :presence
        define_method(:validate_presence) do |attribute|
          'Атрибут не может быть пустым' if attribute.empty? || attribute.nil?
        end
      when :format
        define_method(:validate_format) do |attribute, format|
          'Номер не соответствует формату' if attribute !~ format
        end
      when :type
        define_method(:validate_type) do |attribute, type|
          "Атрибут не соответствуют классу #{type}" if attribute.class != type
        end
      end

      define_method(:validate!) do
        name = instance_variable_get "@#{attribute.to_s.gsub(':', '')}".to_sym
        msg = instance_variable_get :@message
        instance_variable_set(:@message, []) unless msg
        msg = instance_variable_get :@message

        msg << validate_presence(name) if self.methods.include?(:validate_presence)
        msg << validate_format(name, format) if self.methods.include?(:validate_format)
        msg << validate_type(name, format) if self.methods.include?(:validate_type)

        instance_variable_set :@message, msg.compact
      end

      define_method(:valid?) do
        validate!
        msg = instance_variable_get :@message
        raise msg.join('. ') unless msg.empty?
        true
      rescue StandardError => e
        false
      end
    end
  end
end
