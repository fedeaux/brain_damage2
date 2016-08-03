# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Input
      class PolymorphicHybrid < Base
        def initialize(field, options)
          super
          @normalized_name = name.to_s.gsub('_id', '').gsub('_type', '')
          @initialized_inputs = false
        end

        def initialize_inputs
          @inputs = {}

          @options[:inputs].each do |name, options|
            @inputs[name] = {
              name: name,
              model: options[:model],
              label: options[:label],
              input: Factory.create(:input, @field, options)
            }
          end

          @initialized_inputs = true
        end

        def type_select_name
          "#{singular_table_name}[#{@normalized_name}_type]"
        end

        def object_select_name
          "#{singular_table_name}[#{@normalized_name}_id]"
        end

        def specified_inputs
          initialize_inputs unless @initialized_inputs
          @inputs.values
        end
      end
    end
  end
end
