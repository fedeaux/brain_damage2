require_relative 'base'

module BrainDamage
  module View
    module Input
      class NestedForm < Base
        attr_reader :nested_model_class_name
        attr_reader :nested_singular_table_name
        attr_reader :nested_plural_table_name

        def initialize(field, options)
          super

          if field and field.relation
            @nested_model_class_name = field.relation.class_name.to_s
          else
            @nested_model_class_name = name.to_s.singularize.camelcase
          end

          @nested_singular_table_name = @nested_model_class_name.underscore.singularize
          @nested_plural_table_name = @nested_model_class_name.underscore.pluralize
        end

        def explicit_form?
          @options[:explicit_form] || false
        end

        def nested_on
          relation.nested_on
        end
      end
    end
  end
end
