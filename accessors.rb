module Accessors
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def attr_accessor_with_history(*attributes)
      attributes.each do |attribute|
        var_name = "@#{attribute}".to_sym
        history_var_name = "@#{attribute}_history".to_sym
        method_name = "#{attribute}_history".to_sym

        history_method(method_name, history_var_name)
        set_accessor(attribute, var_name, history_var_name)
      end
    end

    private 

    def history_method(name, var)
      define_method(name) { instance_variable_get(var) }
      define_method("#{name}=") do |value|
        instance_variable_set(var, value)
      end
    end

    def set_accessor(attribute, var_name, history_var_name)
      define_method(attribute) { instance_variable_get(var_name) }
      define_method("#{attribute}=".to_sym) do |value|
        instance_variable_set(var_name, value)

        history = self.instance_variable_get history_var_name
        self.instance_variable_set history_var_name, [] unless history
        history = self.instance_variable_get history_var_name
        history << value
      end
    end
  end
end
