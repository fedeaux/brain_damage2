# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class ForeignSinglePageManager < Base
        attr_reader :foreign_model_class_name
        attr_reader :foreign_singular_table_name
        attr_reader :foreign_plural_table_name

        def initialize(field, options)
          super

          default_options = {
            deletable: true,
            editable: true,
            viewable: false,
            explicit_form: false,
            leading_form: false,
            trailing_form: true,
            nested_on: resource_name_according_to_foreign.to_sym
          }

          @spm_options = default_options.merge(options).slice(*default_options.keys)

          @foreign_model_class_name = @field.relation.class_name.to_s
          @foreign_singular_table_name = @foreign_model_class_name.underscore.singularize
          @foreign_plural_table_name = @foreign_model_class_name.underscore.pluralize
        end

        def resource_name_according_to_foreign
          if @field.relation
            @field.relation.resource_name_according_to_foreign
          else
            singular_table_name
          end
        end

        def options_hash
          @spm_options.dup
        end
      end
    end
  end
end
