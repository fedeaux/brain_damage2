require 'erb'
require_relative 'nested_on_hideable'

module BrainDamage
  module View
    module Input
      class PolymorphicSelect < NestedOnHideable
        def initialize(field, options)
          super
          @normalized_name = name.to_s.gsub('_id', '').gsub('_type', '')
        end

        def type_select_name
          "#{@normalized_name}_type"
        end

        def object_select_name
          "#{@normalized_name}_id"
        end

        def options_for_type
          @options[:options].map{ |option|
            "[cet('entities.#{option[:model].to_s.downcase}'), '#{option[:model].to_s}']"
          }.join ', '
        end

        def types_options
          @options[:options]
        end
      end
    end
  end
end
