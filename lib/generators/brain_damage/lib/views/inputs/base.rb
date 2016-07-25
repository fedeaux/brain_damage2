# coding: utf-8
require_relative '../../templateable/field_templateable'

module BrainDamage
  module View
    module Input
      class Base < Templateable::FieldTemplateable
        def tag_options(options = {})
          options = options.merge (@options[:html] || {})
          options[:name] ||= "name_for_input_tag(:#{name}, prefix)"

          '{' + options.map { |key, value|
            "#{key}: #{value}"
          }.join(', ') + '}'
        end

        def dir
          __dir__
        end
      end
    end
  end
end
