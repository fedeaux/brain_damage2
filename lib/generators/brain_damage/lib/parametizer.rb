module BrainDamage
  class Parametizer
    def initialize(resource)
      @resource = resource
    end

    def as_cmd_parameters
      [@resource.name] + columns_as_parameters
    end

    def columns_as_parameters
      @resource.columns.map { |column_name, options| column_as_parameter column_name, options }
    end

    def column_as_parameter(column_name, options)
      "#{column_name.to_s}:#{options[:type].to_s}"
    end
  end
end
